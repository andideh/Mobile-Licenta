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
    func didSelect(value: Any, forItemAtIndex index: Int)
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
            .mapConst(AboutYouFormFactory.defaultForm())
        
        let nextButtonStateOnViewDidLoad = viewDidLoadProperty.signal
            .mapConst(false)
        
        let completedFormCount = AboutYouFormFactory.defaultForm().count
        
        let completedInputs = inputFormProperty.signal
            .filter { $0 == completedFormCount }
            .mapConst(true)
        
        nextButtonState = Signal.merge(nextButtonStateOnViewDidLoad, completedInputs)
        
        itemSelectionProperty.signal
            .skipNil()
            .observeValues { tuple in
                switch tuple.index {
                // age
                case 0:
                    let ageValue = tuple.value as! Int
                    
                    AppEnvironment.current.currenUserProfile.age = ageValue
                    
                // gender
                case 1:
                    let genderValue = tuple.value as! Gender
                    
                    AppEnvironment.current.currenUserProfile.gender = genderValue
                    
                // height
                case 2:
                    let heightValue = tuple.value as! Int
                    
                    AppEnvironment.current.currenUserProfile.height = heightValue
                    
                // weight
                case 3:
                    let weightValue = tuple.value as! Int
                    
                    AppEnvironment.current.currenUserProfile.weight = weightValue
                    
                    
                default: break
                }
            }
        
        goToRegistration = nextButtonTappedProperty.signal

        nextButtonTappedProperty.signal
            .observeValues {
                let currentUserProfile = AppEnvironment.current.currenUserProfile
                let archive = NSKeyedArchiver.archivedData(withRootObject: currentUserProfile)

                UserDefaults.standard.set(archive, forKey: "currentUserProfile")
            }
         
    }

    private let itemSelectionProperty: MutableProperty<(value: Any, index: Int)?> = MutableProperty(nil)
    func didSelect(value: Any, forItemAtIndex index: Int) {
        let tuple = (value, index)
        
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
