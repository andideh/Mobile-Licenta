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
    let currentUserProfile: CurrentUserProfile
    let service: ServiceType
    
    
    init(
        currentUser: User? = nil,
        currentUserProfile: CurrentUserProfile = CurrentUserProfile(),
        service: ServiceType = MockService()) {
        
        self.currentUser = currentUser
        self.currentUserProfile = currentUserProfile
        self.service = service
    }
}
