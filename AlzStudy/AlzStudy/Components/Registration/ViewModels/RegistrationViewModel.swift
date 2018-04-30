//
//  RegistrationViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 03/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Firebase

protocol RegistrationViewModelInputs {
    
    func viewDidLoad()
    
    func fullNameChanged(_ fullName: String)
    
    func emailChanged(_ email: String)
    
    func passwordChanged(_ password: String)
    
    func confirmPasswordChanged(_ password: String)
    
    func registerButtonTapped()
    
    func userRole(_ role: UserRole)
}

protocol RegistrationViewModelOutputs {
    
    var registerButtonState: Signal<(Bool, UIColor), NoError> { get }
    var signInAsPatient: Signal<(), NoError> { get }
    var signInAsDoctor: Signal<(), NoError> { get }
}

protocol RegistrationViewModelType {
    
    var inputs: RegistrationViewModelInputs { get }
    var outputs: RegistrationViewModelOutputs { get }
}


final class RegistrationViewModel: RegistrationViewModelOutputs, RegistrationViewModelInputs, RegistrationViewModelType {
    
    let registerButtonState: Signal<(Bool, UIColor), NoError>
    let signInAsDoctor: Signal<(), NoError>
    let signInAsPatient: Signal<(), NoError>
    
    init() {
        
        let name = self.fullNameProperty.signal
        let email = self.emailChangedProperty.signal
        let password = self.passwordChangedProperty.signal
        let confirmPassword = self.confirmPasswordChangedProperty.signal
        
        let initial = self.viewDidLoadProperty.signal.mapConst(false)
        let initialRole = self.viewDidLoadProperty.signal.mapConst(UserRole.participant)
        let userRole = Signal.merge(initialRole, self.userRoleProperty.signal)
        
        let validName = name.map { $0.count > 2 }
        let validEmail = email.map { $0.count > 4 }
        let validPassword = Signal.combineLatest(password, confirmPassword)
            .filter { $0.count > 6 && $1.count > 6 }
            .map { $0 == $1 }
        
        let buttonEnabled = Signal.combineLatest(validName, validEmail, validPassword)
            .map { $0 && $1 && $2 }
        
        self.registerButtonState = Signal.merge(initial, buttonEnabled)
            .map {
                return $0 ? ($0, UIColor.navy) : ($0, UIColor.lightGray)
            }
        
        let userCreation = Signal.combineLatest(email, password)
            .takeWhen(registerTappedProperty.signal)
            .flatMap(.latest) {
                AppEnvironment.current.service.signup(email: $0.0, password: $0.1).materialize()
            }

        let successfulCreation = userCreation.values()

        // store the newly created user in db
        let storeUser = successfulCreation.combineLatest(with: userRole)
            .flatMap(.latest) {
                AppEnvironment.current.service.store(newUser: $0.0, role: $0.1).materialize()
            }
            .values()
        
//        name.sample(on: userCreation.demoteErrors().ignoreValues())
//            .observeValues {
//                let currentUser = AppEnvironment.current.currentUser
//                currentUser?.profile.fullName = $0
//                
//                AppEnvironment.replaceCurrentEnvironment(currentUser: currentUser)
//            }
        
        // update user profile
//        let profileUpdate = userCreation.flatMap(.latest) { (user: Firebase.User) -> SignalProducer<DatabaseReference, ASError> in
//            let userProfile = (AppEnvironment.current.currentUser?.profile)!
//
//            return AppEnvironment.current.service.update(userProfile: userProfile, uid: user.uid)
//        }

        let signInAction = Signal.combineLatest(successfulCreation, storeUser, name, userRole)
        
        signInAction
//            .on(event: {
//                $0.value.
//            })
//            .flatMap(.latest) {
//                return AppEnvironment.current.service.fetchUserRole(for: $0.0).materialize()
//            }
//            .values()
            .observeValues {
                let currentUser = CurrentUser(firUser: $0.0, role: $0.3)
                currentUser.profile.fullName = $0.2

                AppEnvironment.replaceCurrentEnvironment(currentUser: currentUser)
            }
        

        self.signInAsPatient = signInAction
            .filter { $0.3 == .participant }
            .map { _ in
                AppEnvironment.current.localStorage.set(bool: true, forKey: Key.hasJoined)
                AppEnvironment.current.localStorage.set(bool: false, forKey: Key.isDoctor)
                return
            }
        
        self.signInAsDoctor = signInAction
            .filter { $0.3 == .doctor }
            .map { _ in
                AppEnvironment.current.localStorage.set(bool: true, forKey: Key.hasJoined)
                AppEnvironment.current.localStorage.set(bool: true, forKey: Key.isDoctor)
                return
        }
    }
    
    private let fullNameProperty = MutableProperty<String>("")
    func fullNameChanged(_ fullName: String) {
        self.fullNameProperty.value = fullName
    }

    private let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    private let emailChangedProperty = MutableProperty("")
    func emailChanged(_ email: String) {
        emailChangedProperty.value = email
    }
    
    private let passwordChangedProperty = MutableProperty("")
    func passwordChanged(_ password: String) {
        passwordChangedProperty.value = password
    }
    
    private let confirmPasswordChangedProperty = MutableProperty("")
    func confirmPasswordChanged(_ password: String) {
        confirmPasswordChangedProperty.value = password
    }
    
    private let registerTappedProperty = MutableProperty(())
    func registerButtonTapped() {
        registerTappedProperty.value = ()
    }
    
    private let userRoleProperty = MutableProperty<UserRole>(.participant)
    func userRole(_ role: UserRole) {
        self.userRoleProperty.value = role
    }
    
    var inputs: RegistrationViewModelInputs { return self }
    var outputs: RegistrationViewModelOutputs { return self }
}
