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
    
    func registerAsDoctorChanged(_ value: Bool)
    
}

protocol RegistrationViewModelOutputs {
    
    var isRegisterButtonEnabled: Signal<Bool, NoError> { get }
    var signInAsPatient: Signal<(), NoError> { get }
    var signInAsDoctor: Signal<(), NoError> { get }
}

protocol RegistrationViewModelType {
    
    var inputs: RegistrationViewModelInputs { get }
    var outputs: RegistrationViewModelOutputs { get }
}


final class RegistrationViewModel: RegistrationViewModelOutputs, RegistrationViewModelInputs, RegistrationViewModelType {
    
    let isRegisterButtonEnabled: Signal<Bool, NoError>
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
        
        self.isRegisterButtonEnabled = Signal.merge(initial, buttonEnabled)
        
        let userCreation = Signal.combineLatest(email, password)
            .takeWhen(registerTappedProperty.signal)
            .take(first: 1)
            .flatMap(.latest) {
                AppEnvironment.current.service.signup(email: $0.0, password: $0.1)
            }
        
        // store the newly created user in db
        let storeUser = userCreation.combineLatest(with: userRole.promoteError(ASError.self))
            .flatMap(.latest) {
                AppEnvironment.current.service.store(newUser: $0.0, role: $0.1)
            }
        
        name.sample(on: userCreation.demoteErrors().ignoreValues())
            .observeValues {
                let currentUserProfile = AppEnvironment.current.currentUserProfile
                currentUserProfile.fullName = $0
                
                AppEnvironment.replaceCurrentEnvironment(currentUserProfile: currentUserProfile)
            }
        
        // update user profile
        let profileUpdate = userCreation.flatMap(.latest) { (user: Firebase.User) -> SignalProducer<DatabaseReference, ASError> in
            let userProfile = AppEnvironment.current.currentUserProfile
            
            return AppEnvironment.current.service.update(userProfile: userProfile, uid: user.uid)
        }
        
        let signInAction = Signal.combineLatest(userCreation, storeUser, profileUpdate, userRole.promoteError(ASError.self))
            .materialize()
            .values()
        
        signInAction
            .flatMap(.latest) {
                return AppEnvironment.current.service.fetchUserRole(for: $0.0).materialize()
            }
            .values()
            .observeValues {
                let currentUser = CurrentUser(firUser: $0, role: $1)
                
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
    func registerAsDoctorChanged(_ value: Bool) {
        self.userRoleProperty.value = value ? .doctor : .participant
    }
    
    var inputs: RegistrationViewModelInputs { return self }
    var outputs: RegistrationViewModelOutputs { return self }
}
