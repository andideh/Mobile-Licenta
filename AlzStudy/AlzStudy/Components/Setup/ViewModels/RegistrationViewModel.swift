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
    
    func emailChanged(_ email: String)
    
    func passwordChanged(_ password: String)
    
    func confirmPasswordChanged(_ password: String)
    
    func registerButtonTapped()
    
}

protocol RegistrationViewModelOutputs {
    
    var isRegisterButtonEnabled: Signal<Bool, NoError> { get }
    var signIn: Signal<(), NoError> { get }
}

protocol RegistrationViewModelType {
    
    var inputs: RegistrationViewModelInputs { get }
    var outputs: RegistrationViewModelOutputs { get }
}


final class RegistrationViewModel: RegistrationViewModelOutputs, RegistrationViewModelInputs, RegistrationViewModelType {
    
    let isRegisterButtonEnabled: Signal<Bool, NoError>
    let signIn: Signal<(), NoError>
    
    init() {
        
        let email = emailChangedProperty.signal
        let password = passwordChangedProperty.signal
        let confirmPassword = confirmPasswordChangedProperty.signal
        
        let initial = viewDidLoadProperty.signal.mapConst(false)
        
        let validEmail = email.map { $0.count > 4 }
        let validPassword = Signal.combineLatest(password, confirmPassword)
            .filter { $0.count > 6 && $1.count > 6 }
            .map { $0 == $1 }
        
        let buttonEnabled = Signal.combineLatest(validEmail, validPassword)
            .map { $0 && $1 }
        
        self.isRegisterButtonEnabled = Signal.merge(initial, buttonEnabled)
        
        let userCreation = Signal.combineLatest(email, password)
            .takeWhen(registerTappedProperty.signal)
            .take(first: 1)
            .flatMap(.latest) {
                AppEnvironment.current.service.login(email: $0.0, password: $0.1)
            }
        
        // store the newly created user in db
        let storeUser = userCreation.flatMap(.latest) {
            AppEnvironment.current.service.store(newUser: $0)
        }
        
        // update user profile
        let profileUpdate = userCreation.flatMap(.latest) { (user: Firebase.User) -> SignalProducer<DatabaseReference, ASError> in
            let userProfile = AppEnvironment.current.currentUserProfile
            
            return AppEnvironment.current.service.update(userProfile: userProfile, uid: user.uid)
        }
        
        self.signIn = Signal.combineLatest(userCreation, storeUser, profileUpdate)
            .materialize()
            .values()
            .ignoreValues()
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
    
    var inputs: RegistrationViewModelInputs { return self }
    var outputs: RegistrationViewModelOutputs { return self }
}
