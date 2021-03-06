//
//  AboutYouViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result



protocol AboutYouViewModelInputs {
    
    func viewDidLoad()
    func nextButtonTapped()
    func didCompleteInputForm()
    func didSelect(value: Any, for item: MeasurementsData)
}

protocol AboutYouViewModelOutputs {
    
    var loadForm: Signal<[ParameterViewData], NoError> { get }
    var nextButtonState: Signal<Bool, NoError> { get }
    var goToRegistration: Signal<(), NoError> { get }
}

protocol AboutYouViewModelType {
    
    var inputs: AboutYouViewModelInputs { get }
    var outputs: AboutYouViewModelOutputs { get }
}


final class AboutYouViewModel: AboutYouViewModelType, AboutYouViewModelInputs, AboutYouViewModelOutputs {
    
    let loadForm: Signal<[ParameterViewData], NoError>
    let nextButtonState: Signal<Bool, NoError>
    let goToRegistration: Signal<(), NoError>
    
    init() {
        
        loadForm = viewDidLoadProperty.signal
            .mapConst(MeasurementsFormFactory.defaultForm())
        
        let nextButtonStateOnViewDidLoad = viewDidLoadProperty.signal
            .mapConst(false)
        let completedFormCount = MeasurementsFormFactory.defaultForm().count
        let completedInputs = inputFormProperty.signal
            .filter { $0 == completedFormCount }
            .mapConst(true)
        nextButtonState = Signal.merge(nextButtonStateOnViewDidLoad, completedInputs)
        
        itemSelectionProperty.signal
            .skipNil()
            .observeValues { tuple in
                switch tuple.item {
                // age
                case .age:
                    let ageValue = tuple.value as! Int
                    

                // gender
                case .gender:
                    let genderValue = tuple.value as! Gender
                    

                // height
                case .height:
                    let heightValue = tuple.value as! Int
                    

                // weight
                case .weight:
                    let weightValue = tuple.value as! Int
                    
            }
        }
        
        goToRegistration = nextButtonTappedProperty.signal

         
    }

    private let itemSelectionProperty: MutableProperty<(value: Any, item: MeasurementsData)?> = MutableProperty(nil)
    func didSelect(value: Any, for item: MeasurementsData) {
        let tuple = (value, item)
        
        itemSelectionProperty.value = tuple
    }

    
    private let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
    
    private let nextButtonTappedProperty = MutableProperty(())
    func nextButtonTapped() {
        nextButtonTappedProperty.value = ()
    }
    
    private let inputFormProperty = MutableProperty(0)
    func didCompleteInputForm() {
        let currentValue = inputFormProperty.value
        inputFormProperty.value = currentValue + 1
    }
    
    var inputs: AboutYouViewModelInputs { return self }
    var outputs: AboutYouViewModelOutputs { return self }
}
