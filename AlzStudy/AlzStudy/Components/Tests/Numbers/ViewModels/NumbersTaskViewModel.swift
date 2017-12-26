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

protocol NumbersTaskViewModelInputs {
    
    func configure(with test: Test)
    func viewDidLoad()
    func viewDidAppear()
    func timerDidFire()
    func check(result: String)
    func inputFieldDidAppear()
}

protocol NumbersTaskViewModelOutputs {
    
    var numbersSequence: Signal<String, NoError> { get }
    var hideSequenceAfterTime: Signal<Double, NoError> { get }
    var updateTrialsLeft: Signal<Float, NoError> { get }
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
    let updateTrialsLeft: Signal<Float, NoError>
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
        
        var test: Test?
        
        let (testSignal, testObserver) = Signal<Test, NoError>.pipe()
        
        testProperty.signal
            .skipNil()
            .takeWhen(viewDidAppearProperty.signal)
            .take(first: 1)
            .observeValues {
                test = $0
                testObserver.send(value: $0)
            }
        
        let _ = userSequenceIsValid.observeValues {
            if $0 || test?.trialsLeft == .some(0) {
                test = test?.markedAsDone()
            } else {
                test = test?.decrementedTrialsLeft()
            }
            
            if let theTest = test {
                testObserver.send(value: theTest)
            }
        }
        
        self.invalidateInput = userSequenceIsValid.filter{ !$0 }.ignoreValues()
        
        self.updateTrialsLeft = testSignal.map {
            $0.trialsLeft
        }
        
        let _ = timerFireProperty.signal
            .observeValues {
                test = test?.markedAsFailed()
                testObserver.send(value: test!)
            }
        
        let testIsDone = testSignal.filter { $0.isDone }
        
        self.enableDoneButton = Signal.merge(inputFieldAppearedProperty.signal.mapConst(true),
                                             testIsDone.mapConst(false),
                                             viewLoadedProperty.signal.mapConst(false))
        
        self.stopTimer = testIsDone.ignoreValues()
        
        self.closeScreen = testIsDone.ignoreValues()
    }
    
    
    let testProperty = MutableProperty<Test?>(nil)
    func configure(with test: Test) {
        testProperty.value = test
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
                .flatMap { $0 }
}
