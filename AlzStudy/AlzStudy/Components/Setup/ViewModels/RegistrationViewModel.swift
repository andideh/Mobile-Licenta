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

protocol RegistrationViewModelInputs {
    
    func viewDidLoad()
    
    func nameChanged(_ name: String)
    
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
        
        let name = nameChangedProperty.signal
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
        
        isRegisterButtonEnabled = Signal.merge(initial, buttonEnabled)
        
        signIn = registerTappedProperty.signal
        
        let _ = Signal.combineLatest(name, email, password)
            .takeWhen(signIn)
            .observeValues {
                let user = User(name: $0, email: $1, password: $2)
                
                AppEnvironment.pushEnvironment(currentUser: user)
                
                let archived = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(archived, forKey: "user")
            }
    }
    
    
    private let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    private let nameChangedProperty = MutableProperty("")
    func nameChanged(_ name: String) {
        nameChangedProperty.value = name
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
