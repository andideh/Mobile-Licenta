//
//  Environment.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

struct Environment {
    
    let currentUser: User?
        
    init(
        currentUser: User? = nil ) {
        
        self.currentUser = currentUser
    }
}
