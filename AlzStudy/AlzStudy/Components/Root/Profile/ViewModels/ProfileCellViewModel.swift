//
//  ProfileCellViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol ProfileCellViewModelInputs {
 
    func configure(with viewData: ParameterViewData)
}

protocol ProfileCellViewModelOutputs {
    
    var title: Signal<String, NoError> { get }
    var valueLabel: Signal<String, NoError> { get }
    var image: Signal<UIImage, NoError> { get }
}

protocol ProfileCellViewModelType {
    
    var inputs: ProfileCellViewModelInputs { get }
    var outputs: ProfileCellViewModelOutputs { get }
}

final class ProfileCellViewModel: ProfileCellViewModelType, ProfileCellViewModelInputs, ProfileCellViewModelOutputs {
    
    let title: Signal<String, NoError>
    let valueLabel: Signal<String, NoError>
    let image: Signal<UIImage, NoError>
    
    init() {
        
        let viewData = viewDataProperty.signal.skipNil()
        
        self.title = viewData.map { $0.type.title }
        self.valueLabel = viewData.map {
            switch $0.type {
            case .age: return $0.type.value
            case .gender: return $0.type.value == "0" ? "Male" : "Female"
            case .height: return $0.type.value + "cm"
            case .weight: return $0.type.value + "kg"
            }
        }
        self.image = viewData.map {
            switch $0.type {
            case .age: return #imageLiteral(resourceName: "gender")
            case .gender: return #imageLiteral(resourceName: "gender")
            case .height: return #imageLiteral(resourceName: "gender")
            case .weight: return #imageLiteral(resourceName: "gender")
            }
        }
    }
    
    
    let viewDataProperty = MutableProperty<ParameterViewData?>(nil)
    func configure(with viewData: ParameterViewData) {
        self.viewDataProperty.value = viewData
    }
    
    var inputs: ProfileCellViewModelInputs { return self }
    var outputs: ProfileCellViewModelOutputs { return self }
}
