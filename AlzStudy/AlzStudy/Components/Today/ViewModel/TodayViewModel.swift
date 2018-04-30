//
//  TodayViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 31/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

typealias ChartData = (todo: Int, done: Int)

protocol TodayViewModelInputs {
    
    func viewDidLoad()
}

protocol TodayViewModelOutputs {
    
    var chartData: Signal<ChartData, NoError> { get }
}

protocol TodayViewModelType {
    
    var inputs: TodayViewModelInputs { get }
    var outputs: TodayViewModelOutputs { get }
}

final class TodayViewModel: TodayViewModelOutputs, TodayViewModelInputs, TodayViewModelType {
    
    let chartData: Signal<ChartData, NoError>
    
    init() {
        
        self.chartData = viewLoadedProperty.signal
            .flatMap(.latest) {
                AppEnvironment.current.service.fetchTodayActivity()
            }
            .flatMapError { _ in return .empty }
            .map {
                let done = $0.tasks.filter { $0.isDone }.count
                let todo = $0.tasks.count - done
                let data: ChartData = (todo: todo, done: done)
                
                return data
            }
        
    }
    
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        self.viewLoadedProperty.value = ()
    }
    
    var inputs: TodayViewModelInputs { return self }
    var outputs: TodayViewModelOutputs { return self}
}
