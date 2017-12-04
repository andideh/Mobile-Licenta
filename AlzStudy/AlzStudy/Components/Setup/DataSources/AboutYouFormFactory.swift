//
//  AboutYouFormFactory.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

struct AboutYouFormFactory {
    
    static func defaultForm() -> [ParameterViewData] {
        return [
            ParameterViewData.init(type: .age(-1), additionalMessage: "You must be at least 18 years old in order to be eligible"),
            ParameterViewData.init(type: .gender(.female)),
            ParameterViewData.init(type: .height(-1)),
            ParameterViewData.init(type: .weight(-1))
        ]
    }
}
