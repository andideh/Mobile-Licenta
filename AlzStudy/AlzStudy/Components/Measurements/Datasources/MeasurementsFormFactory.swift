//
//  AboutYouFormFactory.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

struct MeasurementsFormFactory {
    
    static func defaultForm() -> [ParameterViewData] {
        return [
            ParameterViewData.init(icon: Assets.Icons.clock, type: .age(21), additionalMessage: "You must be at least 18 years old in order to be eligible"),
            ParameterViewData.init(icon: Assets.Icons.person, type: .gender(.male)),
            ParameterViewData.init(icon: Assets.Icons.height, type: .height(180)),
            ParameterViewData.init(icon: Assets.Icons.weight, type: .weight(75))
        ]
    }
}
