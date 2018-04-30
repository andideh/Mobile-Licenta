//
//  ActivityCellViewModel.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/9/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol ActivityCellViewModelInputs {
    func configure(with value: Activity)
}

protocol ActivityCellViewModelOutputs {
    var titleText: Signal<String, NoError> { get }
    var icon: Signal<UIImage, NoError> { get }
    var detailText: Signal<String, NoError> { get }
    var alpha: Signal<CGFloat, NoError> { get }
}

protocol ActivityCellViewModelType {
    var inputs: ActivityCellViewModelInputs { get }
    var outputs: ActivityCellViewModelOutputs { get }
}

final class ActivityCellViewModel: ActivityCellViewModelOutputs, ActivityCellViewModelInputs, ActivityCellViewModelType {
    let titleText: Signal<String, NoError>
    let icon: Signal<UIImage, NoError>
    let detailText: Signal<String, NoError>
    let alpha: Signal<CGFloat, NoError>

    init() {
        self.titleText = taskProperty.signal
            .skipNil()
            .map { (viewData: Activity) -> String in
                switch viewData.type {
                case .colorRecognition: return Strings.Activity.tellTheColorTitle
                case .glucoseLevel: return Strings.Activity.glucoseLevelTitle
                case .objectRecognition: return Strings.Activity.guessTheObjectTitle
                case .personRecognition: return Strings.Activity.nameThePersonTitle
                case .rememberNumbers: return Strings.Activity.holdNumbersTitle
                default: return ""
                }
        }

        self.icon = taskProperty.signal
            .skipNil()
            .map {
                switch $0.type {
                case .colorRecognition: return Assets.Icons.colors
                case .glucoseLevel: return Assets.Icons.glucose
                case .objectRecognition: return Assets.Icons.guess
                case .personRecognition: return Assets.Icons.personFilled
                case .rememberNumbers: return Assets.Icons.numbers
                default: return UIImage()
                }
            }

        self.detailText = taskProperty.signal
            .skipNil()
            .map {
                switch $0.type {
                case .colorRecognition: return Strings.Activity.tellTheColorDescription
                case .glucoseLevel: return Strings.Activity.glucoseLevelDescription
                case .objectRecognition: return Strings.Activity.guessTheObjectDescription
                case .personRecognition: return Strings.Activity.nameThePersonDescription
                case .rememberNumbers: return Strings.Activity.holdNumbersDescription
                default: return ""
                }
            }

        self.alpha = taskProperty.signal
            .skipNil()
            .map {
                $0.isDone ? 0.6 : 1.0
            }
    }

    let taskProperty = MutableProperty<Activity?>(nil)
    func configure(with value: Activity) {
        taskProperty.value = value
    }

    var inputs: ActivityCellViewModelInputs { return self }
    var outputs: ActivityCellViewModelOutputs { return self }
}
