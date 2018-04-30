//
//  WalkThroughViewModel.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol WalkThroughViewModelInputs {
    
    // Called when the view did finish loading
    func viewDidLoad()
    
    // Called when the user has tapped the join the study button
    func joinTapped()
    
    func skipButtonTapped()
    
    func joinAsDoctor()
}

protocol WalkThroughViewModelOutputs {
    
    var loadCards: Signal<[CardViewData], NoError> { get }
    var goToSetup: Signal<(), NoError> { get }
    var goToLastCard: Signal<(), NoError> { get }
    var goToDoctorSignup: Signal<(), NoError> { get }
}

protocol WalkThroughViewModelType {
    
    var inputs: WalkThroughViewModelInputs { get }
    var outputs: WalkThroughViewModelOutputs { get }

}

final class WalkThroughViewModel: WalkThroughViewModelType, WalkThroughViewModelInputs, WalkThroughViewModelOutputs {
    
    let loadCards: Signal<[CardViewData], NoError>
    let goToSetup: Signal<(), NoError>
    let goToLastCard: Signal<(), NoError>
    let goToDoctorSignup: Signal<(), NoError>
    
    init() {
        self.loadCards = self.viewDidLoadProperty.signal
            .take(first: 1)
            .map {
                return CardsFactory.makeCards()
            }
        
        self.goToSetup = self.joinTappedProperty.signal
            .on(event: { _ in
                markWalkthroughAsSeen()
            })
            .take(first: 1)
        
        self.goToLastCard = self.skipTappedProperty.signal
        
        self.goToDoctorSignup = self.joinAsDoctorProperty.signal
            .on(event: { _ in
                markWalkthroughAsSeen()
            })
            .take(first: 1)
    }
    
    
    private let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    private let joinTappedProperty = MutableProperty(())
    func joinTapped() {
        self.joinTappedProperty.value = ()
    }
    
    private let skipTappedProperty = MutableProperty(())
    func skipButtonTapped() {
        self.skipTappedProperty.value = ()
    }
    
    private let joinAsDoctorProperty = MutableProperty(())
    func joinAsDoctor() {
        self.joinAsDoctorProperty.value = ()
    }

    
    var inputs: WalkThroughViewModelInputs { return self }
    var outputs: WalkThroughViewModelOutputs { return self }
    
}

private func markWalkthroughAsSeen() {
    AppEnvironment.current.localStorage.set(bool: true, forKey: Key.hasSeenWalkthrough)
}

