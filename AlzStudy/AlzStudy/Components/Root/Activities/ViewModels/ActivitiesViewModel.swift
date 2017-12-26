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
    func didSelect(item index: Int)
}

protocol ActivitiesViewModelsOutputs {
    
    var loadTodayTasks: Signal<[TaskCellViewData], NoError> { get }
    
    var goToTest: Signal<Test, NoError> { get }
    
}

protocol ActivitiesViewModelType {
    
    var inputs: ActivitiesViewModelInputs { get }
    var outputs: ActivitiesViewModelsOutputs { get }
}


final class ActivitiesViewModel: ActivitiesViewModelType, ActivitiesViewModelInputs, ActivitiesViewModelsOutputs {
    
    let loadTodayTasks: Signal<[TaskCellViewData], NoError>
    let goToTest: Signal<Test, NoError>
    
    init() {
        
        let dailyTask = DailyTaskService.makeDailyTask()
        
        self.loadTodayTasks = self.viewLoadedProperty.signal
            .take(first: 1)
            .map { _ in
                dailyTask.tests.map { TaskCellViewData(type: $0.type, isDone: $0.isDone) }
            }
        
        self.goToTest = self.selectedItemProperty.signal
            .map {
                dailyTask.tests[$0]
            }
    }
    
    
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        viewLoadedProperty.value = ()
    }
    
    let selectedItemProperty = MutableProperty<Int>(0)
    func didSelect(item index: Int) {
        selectedItemProperty.value = index
    }
    
    var inputs: ActivitiesViewModelInputs { return self }
    var outputs: ActivitiesViewModelsOutputs { return self }
    
    
}
