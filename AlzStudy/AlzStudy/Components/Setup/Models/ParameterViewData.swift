//
//  ParameterViewData.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

enum Gender: Int {
    case male
    case female
}
enum Parameter {
    case height(Int)
    case age(Int)
    case gender(Gender)
    case weight(Int)
    
    var title: String {
        switch self {
        case .height: return "Your height"
        case .age: return "Your age"
        case .gender: return "Your gender"
        case .weight: return "Your weight"
        }
    }
    
    
    var value: String {
        switch self {
            
        case .age(let value): return "\(value)"
        case .gender(let value): return "\(value.rawValue)"
        case .weight(let value): return "\(value)"
        case .height(let value): return "\(value)"
        
        }
    }
}

class ParameterViewData {
    var type: Parameter
    var isFilled: Bool
    var additionalMessage: String?
    
    init(type: Parameter, additionalMessage: String? = nil) {
        self.type = type
        self.isFilled = false
        self.additionalMessage = additionalMessage
    }
}
