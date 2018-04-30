//
//  ParticipantsViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 14/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ParticipantsViewModelInputs {
    
    func viewDidLoad()
    func didSelectItem(_ index: Int)
    func logoutButtonTapped()
}

protocol ParticipantsViewModelOutputs {
    
    var loadParticipants: Signal<[UserProfile], NoError> { get }
    var goToLogin: Signal<Void, NoError> { get }
}

protocol ParticipantsViewModelType {
    
    var inputs: ParticipantsViewModelInputs { get }
    var outputs: ParticipantsViewModelOutputs { get }
}

final class ParticipantsViewModel: ParticipantsViewModelOutputs, ParticipantsViewModelInputs, ParticipantsViewModelType {
    
    let loadParticipants: Signal<[UserProfile], NoError>
    let goToLogin: Signal<Void, NoError>
    
    init() {
        let viewLoaded = self.viewLoadedProperty.signal.take(first: 1)
        
        
        let usersFetch = viewLoaded
            .flatMap(.latest) {
                AppEnvironment.current.service.fetchParticipants()
            }
            .materialize()
            .values()
        
        self.loadParticipants = usersFetch.map { Array($0.values) }
        
        let logoutAction = self.logoutProperty.signal
            .flatMap(.latest) {
                AppEnvironment.current.service.logout().materialize()
            }
            .values()
        
        logoutAction.observeValues {
            AppEnvironment.replaceCurrentEnvironment(currentUser: nil)
        }
        
        self.goToLogin = logoutAction
    }
    
    
    let viewLoadedProperty = MutableProperty(())
    func viewDidLoad() {
        self.viewLoadedProperty.value = ()
    }
    
    let selectedItemProperty = MutableProperty<Int?>(nil)
    func didSelectItem(_ index: Int) {
        self.selectedItemProperty.value = index
    }
    
    let logoutProperty = MutableProperty(())
    func logoutButtonTapped() {
        self.logoutProperty.value = ()
    }
    
    var inputs: ParticipantsViewModelInputs { return self }
    var outputs: ParticipantsViewModelOutputs { return self }
}
