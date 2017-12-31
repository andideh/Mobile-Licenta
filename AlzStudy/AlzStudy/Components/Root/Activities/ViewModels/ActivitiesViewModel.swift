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


protocol ActivitiesViewModelInputs {
    
    func viewDidLoad()
    func didSelect(item indexPath: IndexPath)
}

protocol ActivitiesViewModelsOutputs {
    
    var loadTodayTasks: Signal<[TaskCellViewData], NoError> { get }
    var loadYesterdayTasks: Signal<[TaskCellViewData], NoError> { get }
    var goToTest: Signal<Test, NoError> { get }
    
}

protocol ActivitiesViewModelType {
    
    var inputs: ActivitiesViewModelInputs { get }
    var outputs: ActivitiesViewModelsOutputs { get }
}


final class ActivitiesViewModel: ActivitiesViewModelType, ActivitiesViewModelInputs, ActivitiesViewModelsOutputs {
    
    let loadTodayTasks: Signal<[TaskCellViewData], NoError>
    let loadYesterdayTasks: Signal<[TaskCellViewData], NoError>
    let goToTest: Signal<Test, NoError>
    
    init() {
        
        let todayTask = self.viewLoadedProperty.signal
            .take(first: 1)
            .flatMap(.latest) {
                return AppEnvironment.current.service.fetchTodayTask().materialize()
            }
        
        self.loadTodayTasks = todayTask.values()
            .map { $0.tests.map { TaskCellViewData(type: $0.type, isDone: $0.isDone) } }
        
        
        let yesterdayTask = self.viewLoadedProperty.signal
            .take(first: 1)
            .flatMap(.latest) {
                return AppEnvironment.current.service.fetchYesterdayTask().materialize()
            }
        
        self.loadYesterdayTasks = yesterdayTask.values()
            .map { $0.tests.map { TaskCellViewData(type: $0.type, isDone: $0.isDone) } }
        
        self.goToTest = self.selectedItemProperty.signal.combineLatest(with: todayTask.values())
            .filter { $0.0?.section == .some(1) } // make only today's tasks selectable
            .map { $0.1.tests[$0.0!.item] }
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
