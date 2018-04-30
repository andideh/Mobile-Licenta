//
//  MeasurementCellViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol MeasurementCellViewModelInputs {
    func configure(with parameter: ParameterViewData)
}

protocol MeasurementCellViewModelOutputs {
    var titleText: Signal<String, NoError> { get }
    var detailText: Signal<String, NoError> { get }
    var icon: Signal<UIImage, NoError> { get }
}

protocol MeasurementCellViewModelType {
    var inputs: MeasurementCellViewModelInputs { get }
    var outputs: MeasurementCellViewModelOutputs { get }
}

final class MeasurementCellViewModel: MeasurementCellViewModelOutputs, MeasurementCellViewModelInputs, MeasurementCellViewModelType {
    
    let titleText: Signal<String, NoError>
    let detailText: Signal<String, NoError>
    let icon: Signal<UIImage, NoError>
    
    init() {
        let parameter = parameterProperty.signal
            .skipNil()
        titleText = parameter.map { $0.type.title }
        detailText = parameter.map { $0.type.value }
        icon = parameter.map { $0.icon }
    }
    
    let parameterProperty: MutableProperty<ParameterViewData?> = MutableProperty(nil)
    func configure(with parameter: ParameterViewData) {
        parameterProperty.value = parameter
    }
    
    var inputs: MeasurementCellViewModelInputs { return self }
    var outputs: MeasurementCellViewModelOutputs { return self }
}
