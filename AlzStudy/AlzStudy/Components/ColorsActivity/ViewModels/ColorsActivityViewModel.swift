//
//  ColorsActivityViewModel.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/14/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Firebase
import Result

protocol ColorsActivityViewModelInputs {
    var viewLoaded: Signal<Void, NoError>.Observer { get }
    var selectedItem:  Signal<Int, NoError>.Observer { get }
    var activity: Signal<Activity, NoError>.Observer { get }
}

protocol ColorsActivityViewModelOutputs {
    var displayedColor: Signal<UIColor, NoError> { get }
    var answerOptions: Signal<[String], NoError> { get }
    var dismiss: Signal<Void, NoError> { get }
}

protocol ColorsActivityViewModelType {
    var inputs: ColorsActivityViewModelInputs { get }
    var outputs: ColorsActivityViewModelOutputs { get }
}

final class ColorsActivityViewModel: ColorsActivityViewModelOutputs, ColorsActivityViewModelInputs, ColorsActivityViewModelType {

    // inputs
    let (viewLoadedSignal, viewLoaded) = Signal<Void, NoError>.pipe()
    let (selectedItemSignal, selectedItem) = Signal<Int, NoError>.pipe()
    let (goToNextSignal, goToNext) = Signal<Void, NoError>.pipe()
    let (activitySignal, activity) = Signal<Activity, NoError>.pipe()

    // outputs
    let displayedColor: Signal<UIColor, NoError>
    let answerOptions: Signal<[String], NoError>
    let dismiss: Signal<Void, NoError>

    private static let noTest: Double = 3.0

    init() {
        let initialTest = ColorTestFactory.makeTest()
        let currentTestProperty = MutableProperty<ColorTest>(initialTest)
        let noTestProperty = MutableProperty<Double>(ColorsActivityViewModel.noTest)

        viewLoadedSignal.observeValues {
            currentTestProperty.value = initialTest
        }
        displayedColor = currentTestProperty.signal
            .map { $0.color.uiColor }
        answerOptions = currentTestProperty.signal
            .map { $0.options.map { $0.rawValue } }

        let result = selectedItemSignal.withLatestFrom(currentTestProperty.signal)
            .scan(0.0) {
                let selectedColor = $1.1.options[$1.0]
                return $0 + (selectedColor == $1.1.color ? 1 : 0)
            }

        goToNextSignal.observeValues {
            if noTestProperty.value > 1 {
                currentTestProperty.value = ColorTestFactory.makeTest()
            }
        }

        let updateResult = Signal.combineLatest(noTestProperty.signal, result, activitySignal)
            .filter { $0.0 == 0 }
            .flatMap(.latest) { tuple -> SignalProducer<Signal<DatabaseReference, ASError>.Event, NoError> in
                tuple.2.successRate = tuple.1 / ColorsActivityViewModel.noTest
                tuple.2.isDone = true
                return AppEnvironment.current.service.update(task: tuple.2).materialize()
            }

        dismiss = updateResult.values().ignoreValues()

        selectedItemSignal.signal
            .delay(0.15, on: QueueScheduler.main)
            .observeValues { [weak self] _ in
                self?.goToNext.send(value: ())
                noTestProperty.value -= 1
        }
    }

    var inputs: ColorsActivityViewModelInputs { return self }
    var outputs: ColorsActivityViewModelOutputs { return self }
}
