//
//  InfoCellViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol InfoCellViewModelInputs {
    
    func configure(with parameter: ParameterViewData)
    
}

protocol InfoCellViewModelOutputs {
    
    var titleText: Signal<String, NoError> { get }
    var checkmarkImage: Signal<UIImage, NoError> { get }
    
}

protocol InfoCellViewModelType {
    
    var inputs: InfoCellViewModelInputs { get }
    var outputs: InfoCellViewModelOutputs { get }
    
}


final class InfoCellViewModel: InfoCellViewModelOutputs, InfoCellViewModelInputs, InfoCellViewModelType {
    
    let titleText: Signal<String, NoError>
    let checkmarkImage: Signal<UIImage, NoError>
    
    init() {
        
        let parameter = parameterProperty.signal
            .skipNil()
        
        titleText = parameter.map { $0.type.title }
        checkmarkImage = parameter.map { $0.isFilled ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "empty_checkmark") }
        
        
        
    }
    
    let parameterProperty: MutableProperty<ParameterViewData?> = MutableProperty(nil)
    func configure(with parameter: ParameterViewData) {
        parameterProperty.value = parameter
    }
    
    
    var inputs: InfoCellViewModelInputs { return self }
    var outputs: InfoCellViewModelOutputs { return self }
}
