//
//  UserProfile.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 03/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase

enum Gender: Int, Codable {
    case male
    case female
}

final class UserProfile: Codable {
    
    var fullName: String = ""
    var age: Int = -1
    var weight: Int = -1
    var height: Int = -1
    var gender: Gender = .male
    
}

