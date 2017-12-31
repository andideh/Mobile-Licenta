//
//  TaskCellViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol TaskCellViewModelInputs {
    
    func configure(with value: TaskCellViewData)
    
}

protocol TaskCellViewModelOutputs {
    
    var titleText: Signal<String, NoError> { get }
    var statusImage: Signal<UIImage, NoError> { get }
    var textColor: Signal<UIColor, NoError> { get }
    
}

protocol TaskCellViewModelType {
    
    var inputs: TaskCellViewModelInputs { get }
    var outputs: TaskCellViewModelOutputs { get }
}

final class TaskCellViewModel: TaskCellViewModelOutputs, TaskCellViewModelInputs, TaskCellViewModelType {

    let titleText: Signal<String, NoError>
    let statusImage: Signal<UIImage, NoError>
    let textColor: Signal<UIColor, NoError>
    
    init() {
        
        self.titleText = taskProperty.signal
            .skipNil()
            .map { (viewData: TaskCellViewData) -> String in
                let text: String
                switch viewData.type {
                case .memory: text = "Take memory test"
                case .colors: text = "Take colors test"
                case .numbers: text = "Take counting test"
                case .glucose: text = "Take glucose level"
                }
                
                return text
            }
        
        self.statusImage = taskProperty.signal
            .skipNil()
            .map { (viewData: TaskCellViewData) -> UIImage in
                return viewData.isDone ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "empty_checkmark")
            }
        
        self.textColor = taskProperty.signal
            .skipNil()
            .map {
                return $0.isDone ? UIColor.lightGray : UIColor.black
            }
        
    }
    
    
    let taskProperty = MutableProperty<TaskCellViewData?>(nil)
    func configure(with value: TaskCellViewData) {
        taskProperty.value = value
    }
    
    
    var inputs: TaskCellViewModelInputs { return self }
    var outputs: TaskCellViewModelOutputs { return self }
}

