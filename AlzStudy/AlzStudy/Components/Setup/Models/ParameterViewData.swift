//
//  ParameterViewData.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

enum Gender: String {
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
    
    mutating func modify(_ newValue: String) {
        switch self {
        case .height: self = .height(Int(newValue)!)
        case .age: self = .age(Int(newValue)!)
        case .gender: self = .gender(Gender.init(rawValue: newValue) ?? .male)
        case .weight: self = .weight(Int(newValue)!)
        }
    }
    
    var value: String {
        switch self {
            
        case .age(let value): return "\(value)"
        case .gender(let value): return value.rawValue
        case .weight(let value): return "\(value)"
        case .height(let value): return "\(value)"
        
        }
    }
}

class ParameterViewData {
    var type: Parameter
    var isFilled: Bool
    
    init(type: Parameter) {
        self.type = type
        self.isFilled = false
    }
}
