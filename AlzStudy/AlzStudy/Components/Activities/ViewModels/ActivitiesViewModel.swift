 //
//  ActivitiesViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import Firebase

protocol ActivitiesViewModelInputs {
    func viewDidLoad()
    func didSelect(item indexPath: IndexPath)
}

protocol ActivitiesViewModelsOutputs {
    var loadTodoTasks: Signal<[Activity], NoError> { get }
    var loadDoneTasks: Signal<[Activity], NoError> { get }
    var clearTodoTasks: Signal<Void, NoError> { get }
    var clearDoneTasks: Signal<Void, NoError> { get }
    var goToColorActivity: Signal<Activity, NoError> { get }
    var goToNumbersActivity: Signal<Activity, NoError> { get }
    var goToGlucoseActivity: Signal<Activity, NoError> { get }
}

protocol ActivitiesViewModelType {
    var inputs: ActivitiesViewModelInputs { get }
    var outputs: ActivitiesViewModelsOutputs { get }
}

final class ActivitiesViewModel: ActivitiesViewModelType, ActivitiesViewModelInputs, ActivitiesViewModelsOutputs {
    var loadTodoTasks: Signal<[Activity], NoError>
    let loadDoneTasks: Signal<[Activity], NoError>
    let clearDoneTasks: Signal<Void, NoError>
    let clearTodoTasks: Signal<Void, NoError>
    let goToColorActivity: Signal<Activity, NoError>
    let goToNumbersActivity: Signal<Activity, NoError>
    let goToGlucoseActivity: Signal<Activity, NoError>

    init() {
        let taskFetch = self.viewLoadedProperty.signal
            .flatMap(.latest) {
                return AppEnvironment.current.service.fetchTodayActivity().materialize()
            }

        let recoverFromError = taskFetch.errors().filter { $0 == .jsonParseError }
            .flatMap(.latest) { (error: ASError) -> SignalProducer<DailyActivity, ASError> in
                if case .jsonParseError = error {
                    return AppEnvironment.current.service.createTodayActivity()
                }

                return .init(error: error)
            }
            .materialize()

        let todayTask = Signal.merge(recoverFromError.values(), taskFetch.values()).map { $0.tasks }

        let todoTasks = todayTask.map {
            $0.filter { !$0.isDone }
        }
        self.loadTodoTasks = todoTasks.filter { $0.count > 0 }
        self.clearTodoTasks = todoTasks.filter {
            $0.count == 0
        }.ignoreValues()

        let doneTasks = todayTask.map {
            $0.filter { $0.isDone}
        }
        self.loadDoneTasks = doneTasks.filter { $0.count > 0 }
        self.clearDoneTasks = doneTasks.filter { $0.count == 0 }.ignoreValues()

        let selectedActivity = self.selectedItemProperty.signal.withLatest(from: todoTasks)
            .map { $0.1[$0.0!.item] }

        self.goToColorActivity = selectedActivity.filter { $0.type == .colorRecognition }
        self.goToNumbersActivity = selectedActivity.filter { $0.type == .rememberNumbers }
        self.goToGlucoseActivity = selectedActivity.filter { $0.type == .glucoseLevel }
    }
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        viewLoadedProperty.value = ()
    }
    
    let selectedItemProperty = MutableProperty<IndexPath?>(nil)
    func didSelect(item index: IndexPath) {
        selectedItemProperty.value = index
    }

    var inputs: ActivitiesViewModelInputs { return self }
    var outputs: ActivitiesViewModelsOutputs { return self }
}
