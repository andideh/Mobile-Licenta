//
//  Activity.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 3/1/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation

class Activity: Codable {    
    let type: ActivityType
    var successRate: Double
    var isDone: Bool
    var metadata: String
    
    init(type: ActivityType, isDone: Bool = false) {
        self.type = type
        self.successRate = 0.0
        self.isDone = isDone
        self.metadata = ""
    }
}
