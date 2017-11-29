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
    
}

protocol WalkThroughViewModelOutputs {
    
    var loadCards: Signal<[CardViewData], NoError> { get }
    var goToSetup: Signal<(), NoError> { get }
}

protocol WalkThroughViewModelType {
    
    var inputs: WalkThroughViewModelInputs { get }
    var outputs: WalkThroughViewModelOutputs { get }

}

final class WalkThroughViewModel: WalkThroughViewModelType, WalkThroughViewModelInputs, WalkThroughViewModelOutputs {
    
    let loadCards: Signal<[CardViewData], NoError>
    let goToSetup: Signal<(), NoError>
    
    
    init() {
        loadCards = viewDidLoadProperty.signal
            .take(first: 1)
            .map {
                return CardsFactory.makeCards()
            }
        
        goToSetup = joinTappedProperty.signal
            .take(first: 1)
    }
    
    
    private let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    private let joinTappedProperty = MutableProperty(())
    func joinTapped() {
        joinTappedProperty.value = ()
    }

    
    var inputs: WalkThroughViewModelInputs { return self }
    var outputs: WalkThroughViewModelOutputs { return self }
    
}


