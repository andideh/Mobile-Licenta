//
//  NumbersViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

private enum Constants {
    static let trials: Double = 5.0
}

protocol NumbersTaskViewModelInputs {
    func configure(with activity: Activity)
    func viewDidLoad()
    func viewDidAppear()
    func timerDidFire()
    func check(result: String)
    func inputFieldDidAppear()
}

protocol NumbersTaskViewModelOutputs {
    var numbersSequence: Signal<String, NoError> { get }
    var hideSequenceAfterTime: Signal<Double, NoError> { get }
    var updateTrialsLeft: Signal<Double, NoError> { get }
    var startTimer: Signal<Double, NoError> { get }
    var enableDoneButton: Signal<Bool, NoError> { get }
    var stopTimer: Signal<(), NoError> { get }
    var invalidateInput: Signal<(), NoError> { get }
    var closeScreen: Signal<(), NoError> { get }
}

protocol NumbersTaskViewModelType {
    var inputs: NumbersTaskViewModelInputs { get }
    var outputs: NumbersTaskViewModelOutputs { get }
}

final class NumbersTaskViewModel: NumbersTaskViewModelType, NumbersTaskViewModelOutputs, NumbersTaskViewModelInputs {
    let numbersSequence: Signal<String, NoError>
    let hideSequenceAfterTime: Signal<Double, NoError>
    let updateTrialsLeft: Signal<Double, NoError>
    let startTimer: Signal<Double, NoError>
    let enableDoneButton: Signal<Bool, NoError>
    let stopTimer: Signal<(), NoError>
    let invalidateInput: Signal<(), NoError>
    let closeScreen: Signal<(), NoError>
    
    init() {
        
        // 1. generate random sequence of numbers
        let sequence = RandomSequenceGenerator.generate(4)
        
        // 2. signal the sequence
        self.numbersSequence = viewLoadedProperty.signal
            .mapConst(sequence.reduce("", { $0 + " " + String(describing: $1)}))
        
        self.hideSequenceAfterTime = viewDidAppearProperty.signal
            .mapConst(5.0)

        self.startTimer = inputFieldAppearedProperty.signal
            .mapConst(30.0)
        
        let userSequenceIsValid = self.userResult.signal
            .map(parse(string:))
            .map {
                $0 == sequence
            }
        
        var activity: Activity?
        
        let (activitySignal, activityObserver) = Signal<Activity, NoError>.pipe()
        
        activityProperty.signal
            .skipNil()
            .takeWhen(viewDidAppearProperty.signal)
            .take(first: 1)
            .observeValues {
                activity = $0
                activityObserver.send(value: $0)
            }

        let trialsLeft = MutableProperty<Double>(Constants.trials)

        self.updateTrialsLeft = Signal.merge(inputFieldAppearedProperty.signal.mapConst(Constants.trials), trialsLeft.signal)

        userSequenceIsValid.observeValues {
            if $0 || trialsLeft.value == 0 {
                activity?.isDone = true
            } else {
                trialsLeft.value = trialsLeft.value - 1
            }

            if let activity = activity {
                activityObserver.send(value: activity)
            }
        }

        self.invalidateInput = userSequenceIsValid.filter{ !$0 }.ignoreValues()

        let _ = timerFireProperty.signal
            .observeValues {
                trialsLeft.value = 0
                activity?.isDone = true
                activityObserver.send(value: activity!)
            }
        
        let taskIsDone = activitySignal.filter { $0.isDone }
        taskIsDone.observeValues {
            $0.successRate = trialsLeft.value / Constants.trials
            print($0.successRate)
        }
        
        self.enableDoneButton = Signal.merge(inputFieldAppearedProperty.signal.mapConst(true),
                                             taskIsDone.mapConst(false),
                                             viewLoadedProperty.signal.mapConst(false))
        self.stopTimer = taskIsDone.ignoreValues()

        self.closeScreen = taskIsDone
            .flatMap(.latest) {
                return AppEnvironment.current.service.update(task: $0).materialize()
            }
            .values()
            .ignoreValues()
    }
    
    let activityProperty = MutableProperty<Activity?>(nil)
    func configure(with activity: Activity) {
        activityProperty.value = activity
    }
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        viewLoadedProperty.value = ()
    }
    
    let viewDidAppearProperty = MutableProperty<Void>(())
    func viewDidAppear() {
        viewDidAppearProperty.value = ()
    }
    
    let timerFireProperty = MutableProperty<Void>(())
    func timerDidFire() {
        timerFireProperty.value = ()
    }
    
    let userResult = MutableProperty<String>("")
    func check(result: String) {
        self.userResult.value = result
    }
    
    let inputFieldAppearedProperty = MutableProperty<Void>(())
    func inputFieldDidAppear() {
        self.inputFieldAppearedProperty.value = ()
    }
    
    var inputs: NumbersTaskViewModelInputs { return self }
    var outputs: NumbersTaskViewModelOutputs { return self }
}


private func parse(string: String) -> [Int] {
    return string.map { String($0) }
                .map { Int($0) }
                .compactMap { $0 }
}
