//
//  LoginViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol LoginViewModelInputs {
    
    func viewDidLoad()
    func loginButtonTapped()
    func emailChanged(_ email: String)
    func passwordChanged(_ password: String)
}

protocol LoginViewModelOutputs {
    
    var loginButtonState: Signal<(Bool, UIColor), NoError> { get }
    var goToMain: Signal<(), NoError> { get }
//    var showAlert: Signal<String, NoError> { get }
    
}

protocol LoginViewModelType {
    
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}


final class LoginViewModel: LoginViewModelType, LoginViewModelOutputs, LoginViewModelInputs {
    
    let loginButtonState: Signal<(Bool, UIColor), NoError>
    let goToMain: Signal<(), NoError>
//    let showAlert: Signal<String, NoError>
    
    init() {
        
        let initialState = viewLoadedProperty.signal
            .map { (false, UIColor.lightGray) }
        
        let email = emailChangedProperty.signal
        let password = passwordChangedProperty.signal.filter { $0.count > 6 }
        
        let enabledState = Signal.combineLatest(email, password)
            .map { _ in return (true, Theme.mainColor) }
        
        self.loginButtonState = Signal.merge(initialState, enabledState)
        
        let loginAction = Signal.combineLatest(email, password)
            .takeWhen(loginTappedProperty.signal)
            .flatMap(.latest) {
                AppEnvironment.current.service.login(email: $0.0, password: $0.1).materialize()
            }
            .values()
        
        loginAction
            .flatMap(.latest) {
                return AppEnvironment.current.service.fetchUserRole(for: $0).materialize()
            }
            .values()
            .observeValues {
                let currentUser = CurrentUser(firUser: $0, role: $1)
                
                AppEnvironment.replaceCurrentEnvironment(currentUser: currentUser)                            
                AppEnvironment.current.localStorage.set(bool: $1 == .doctor, forKey: Key.isDoctor)
            }
            
        self.goToMain = loginAction.ignoreValues()
    }
    
    private let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        self.viewLoadedProperty.value = ()
    }
    
    private let loginTappedProperty = MutableProperty<Void>(())
    func loginButtonTapped() {
        self.loginTappedProperty.value = ()
    }
    
    private let emailChangedProperty = MutableProperty("")
    func emailChanged(_ email: String) {
        emailChangedProperty.value = email
    }
    
    private let passwordChangedProperty = MutableProperty("")
    func passwordChanged(_ password: String) {
        passwordChangedProperty.value = password
    }
    
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
}
