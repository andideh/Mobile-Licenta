//
//  ParameterViewData.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

enum Parameter {
    case height(Int)
    case age(Int)
    case gender(Gender)
    case weight(Int)
}

extension Parameter {
    var title: String {
        switch self {
        case .height: return "Height"
        case .age: return "Age"
        case .gender: return "Gender"
        case .weight: return "Weight"
        }
    }

    var value: String {
        switch self {
        case .age(let value): return "\(value)y/o"
        case .gender(let value): return value.rawValue == 0 ? "Male" : "Female"
        case .weight(let value): return "\(value)kg"
        case .height(let value): return "\(value)"
        }
    }
}

class ParameterViewData {
    let icon: UIImage
    var type: Parameter
    var isFilled: Bool
    var additionalMessage: String?
    
    init(icon: UIImage = UIImage(), type: Parameter, additionalMessage: String? = nil) {
        self.icon = icon
        self.type = type
        self.isFilled = false
        self.additionalMessage = additionalMessage
    }
}
