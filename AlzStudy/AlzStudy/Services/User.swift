//
//  User.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase

class CurrentUser {
    
    let firUser: User
    let role: UserRole
    
    init(firUser: User, role: UserRole) {
        self.firUser = firUser
        self.role = role
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        self.email = aDecoder.decodeObject(forKey: Keys.email.rawValue) as! String
//        self.password = aDecoder.decodeObject(forKey: Keys.password.rawValue) as! String
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.email, forKey: Keys.email.rawValue)
//        aCoder.encode(self.password, forKey: Keys.password.rawValue)
//    }
    
}
