//
//  ProfileViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import UIKit


protocol ProfileViewModelInputs {
    
    func viewDidLoad()
    func logoutButtonTapped()
    
}

protocol ProfileViewModelOuputs {
 
    var logoutButtonConfiguration: Signal<UIColor, NoError> { get }
    var loadProfile: Signal<[ParameterViewData], NoError> { get }
    var goToLoginScreen: Signal<(), NoError> { get }
}

protocol ProfileViewModelType {
    
    var inputs: ProfileViewModelInputs { get }
    var outputs: ProfileViewModelOuputs { get }

}


final class ProfileViewModel: ProfileViewModelType, ProfileViewModelInputs, ProfileViewModelOuputs {
    
    let logoutButtonConfiguration: Signal<UIColor, NoError>
    let loadProfile: Signal<[ParameterViewData], NoError>
    let goToLoginScreen: Signal<(), NoError>
    
    init() {
        
        self.logoutButtonConfiguration = viewLoadedProperty.signal
            .take(first: 1)
            .map {
                return Theme.mainColor
            }
        
        self.loadProfile = viewLoadedProperty.signal
            .take(first: 1)
            .flatMap(.latest) { AppEnvironment.current.service.fetchProfile() }
            .map {
                let ageParam = Parameter.age($0.age)
                let age = ParameterViewData(type: ageParam)
                
                let heightParam = Parameter.height($0.height)
                let height = ParameterViewData(type: heightParam)
                
                let weightParam = Parameter.height($0.weight)
                let weight = ParameterViewData(type: weightParam)
                
                let genderParam = Parameter.gender($0.gender)
                let gender = ParameterViewData(type: genderParam)
                
                return [age, gender, height, weight]
            }
            .materialize()
            .values()
        
        self.goToLoginScreen = self.logoutProperty.signal
            .flatMap(.latest) {
                AppEnvironment.current.service.logout()
            }
            .materialize()
            .values()
        
    }
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
         self.viewLoadedProperty.value = ()
    }
    
    let logoutProperty = MutableProperty<Void>(())
    func logoutButtonTapped() {
        self.logoutProperty.value = ()
    }
    
    var inputs: ProfileViewModelInputs { return self }
    var outputs: ProfileViewModelOuputs { return self }
}
