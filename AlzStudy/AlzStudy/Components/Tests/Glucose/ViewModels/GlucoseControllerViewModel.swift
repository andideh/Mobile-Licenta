//
//  GlucoseControllerViewModel.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 1/12/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol GlucoseControllerViewModelInputs {
    
    func viewDidLoad()
    func doneButtonTapped()
    func glucoseTextFieldChanged(_ value: String?)
    func configure(test: Test)
}

protocol GlucoseControllerViewModelOutputs {
    
    var doneButtonState: Signal<(Bool, UIColor), NoError> { get }
    var closeScreen: Signal<Void, NoError> { get }
    
}

protocol GlucoseControllerViewModelType {
    
    var inputs: GlucoseControllerViewModelInputs { get }
    var outputs: GlucoseControllerViewModelOutputs { get }
}

final class GlucoseControllerViewModel: GlucoseControllerViewModelOutputs, GlucoseControllerViewModelInputs, GlucoseControllerViewModelType {
    
    let doneButtonState: Signal<(Bool, UIColor), NoError>
    let closeScreen: Signal<Void, NoError>
    
    init() {
        let glucoseText = self.glucoseValueProperty.signal.skipNil()

        let disabledState = self.viewLoadedProperty.signal.take(first: 1)
            .mapConst((false, UIColor.lightGray))
        let enabledState = glucoseText
            .filter { $0.count >= 2 }
            .mapConst((true, Theme.mainColor))
        
        self.doneButtonState = Signal.merge(disabledState, enabledState)
        self.closeScreen = self.doneButtonTappedProperty.signal
    }
    
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        self.viewLoadedProperty.value = ()
    }
    
    let testProperty = MutableProperty<Test?>(nil)
    func configure(test: Test) {
        self.testProperty.value = test
    }
    
    let doneButtonTappedProperty = MutableProperty<Void>(())
    func doneButtonTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    let glucoseValueProperty = MutableProperty<String?>(nil)
    func glucoseTextFieldChanged(_ value: String?) {
        self.glucoseValueProperty.value = value
    }
    
    var inputs: GlucoseControllerViewModelInputs { return self }
    var outputs: GlucoseControllerViewModelOutputs { return self }
}
