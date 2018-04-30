//
//  AboutYouData.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/11/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


enum MeasurementsData: Int {
    
    case age
    case gender
    case weight
    case height
    
    var values: [Any] {
        switch self {
            
        case .age:
            var data: [Int] = []
            for i in (18...99) {
                data.append(i)
            }
            return data
            
        case .gender:
            return ["Male", "Female"]
            
        case .weight:
            var data: [Int] = []
            for i in (40...200) {
                data.append(i)
            }
            return data
            
        case .height:
            var data: [Int] = []
            for i in (130...200) {
                data.append(i)
            }
            return data
        }
    }
    
    
    
}
