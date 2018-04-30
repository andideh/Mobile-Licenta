//
//  MeasurementsViewModel.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/31/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Firebase

protocol MeasurementsViewModelInputs {
    func viewDidLoad()
    func nextButtonTapped()
    func didCompleteInputForm()
    func didSelect(value: Any, for item: MeasurementsData)
}

protocol MeasurementsViewModelOutputs {
    var loadForm: Signal<[ParameterViewData], NoError> { get }
    var nextButtonState: Signal<Bool, NoError> { get }
    var goToNext: Signal<(), NoError> { get }
    var disclaimer: Signal<String, NoError> { get }
    var ageData: [Int] { get }
    var weightData: [Int] { get }
    var heightData: [Int] { get }
    var genderData: [String] { get }
}

protocol MeasurementsViewModelType {
    var inputs: MeasurementsViewModelInputs { get }
    var outputs: MeasurementsViewModelOutputs { get }
}

final class MeasurementsViewModel: MeasurementsViewModelType, MeasurementsViewModelInputs, MeasurementsViewModelOutputs {

    let loadForm: Signal<[ParameterViewData], NoError>
    let nextButtonState: Signal<Bool, NoError>
    let goToNext: Signal<(), NoError>
    let disclaimer: Signal<String, NoError>

    let ageData: [Int] = MeasurementsData.age.values as! [Int]
    let weightData: [Int] = MeasurementsData.weight.values as! [Int]
    let heightData: [Int] = MeasurementsData.height.values as! [Int]
    let genderData: [String] = MeasurementsData.gender.values as! [String]

    init() {
        let viewLoaded = viewDidLoadProperty.signal.take(first: 1)
        
        var formDataSource = MeasurementsFormFactory.defaultForm()
        let updateForm = MutableProperty<[ParameterViewData]>.init(formDataSource)

        loadForm = Signal.merge(updateForm.signal, viewLoaded.mapConst(formDataSource))
        disclaimer = viewLoaded.mapConst(Strings.Measurements.disclaimer)

        let nextButtonStateOnViewDidLoad = viewLoaded.mapConst(false)
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
                    AppEnvironment.current.currentUser?.profile.age = ageValue
                    formDataSource[0].type = .age(ageValue)

                // gender
                case .gender:
                    let genderValue = tuple.value as! Gender
                    AppEnvironment.current.currentUser?.profile.gender = genderValue
                    formDataSource[1].type = .gender(genderValue)

                // height
                case .height:
                    let heightValue = tuple.value as! Int
                    AppEnvironment.current.currentUser?.profile.height = heightValue
                    formDataSource[2].type = .height(heightValue)

                // weight
                case .weight:
                    let weightValue = tuple.value as! Int
                    AppEnvironment.current.currentUser?.profile.weight = weightValue
                    formDataSource[3].type = .weight(weightValue)
                }
        }

        inputFormProperty.signal.observeValues { _ in
            updateForm.value = formDataSource
        }

        goToNext = nextButtonTappedProperty.signal.flatMap(.latest) { _ -> SignalProducer<DatabaseReference, ASError> in
            let user = (AppEnvironment.current.currentUser)!
            let userProfile = user.profile

            return AppEnvironment.current.service.update(userProfile: userProfile, uid: user.uid)
        }
        .materialize()
        .values()
        .ignoreValues()
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

    var inputs: MeasurementsViewModelInputs { return self }
    var outputs: MeasurementsViewModelOutputs { return self }
}

