//
//  TaskType.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

enum ActivityType: String, Codable {
    
    case memory
    case colors
    case numbers
    case glucose
    
    // correct ones
    
    case rememberNumbers
    case colorRecognition
    case personRecognition
    case objectRecognition
    case glucoseLevel

}
