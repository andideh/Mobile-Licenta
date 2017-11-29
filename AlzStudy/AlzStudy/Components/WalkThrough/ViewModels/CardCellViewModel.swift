//
//  CardCellViewModel.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/19/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol CardCellViewModelInputs {
    
    func configureWith(viewData: CardViewData)
}

protocol CardCellViewModelOutputs {
    
    var cardImage: Signal<UIImage, NoError> { get }
    var titleText: Signal<String, NoError> { get }
    var descriptionText: Signal<String, NoError> { get }
    var backgroundColor: Signal<UIColor, NoError> { get }
    
}

protocol CardCellViewModelType {
    var inputs: CardCellViewModelInputs { get }
    var outputs: CardCellViewModelOutputs { get }
}

final class CardCellViewModel: CardCellViewModelOutputs, CardCellViewModelInputs, CardCellViewModelType {
    
    let cardImage: Signal<UIImage, NoError>
    let titleText: Signal<String, NoError>
    let descriptionText: Signal<String, NoError>
    let backgroundColor: Signal<UIColor, NoError>
    
    init() {
        
        let data = viewDataProperty.signal.skipNil()
        
        cardImage = data.map { $0.image }
        titleText = data.map { $0.title }
        descriptionText = data.map { $0.description }
        backgroundColor = data.map { $0.color }
        
    }
    
    private let viewDataProperty = MutableProperty<CardViewData?>(nil)
    func configureWith(viewData: CardViewData) {
        viewDataProperty.value = viewData
    }
    
    var inputs: CardCellViewModelInputs { return self }
    var outputs: CardCellViewModelOutputs { return self }
}
