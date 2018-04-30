//
//  User.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase

enum UserRole: Int, Codable {
    case participant
    case doctor
}

class CurrentUser {
    
    let firUser: User?
    let role: UserRole
    let profile: UserProfile
    
    var uid: String {
        return firUser?.uid ?? ""
    }
    
    init(firUser: User?, role: UserRole, profile: UserProfile = UserProfile()) {
        self.firUser = firUser
        self.role = role
        self.profile = profile
    }
}
