//
//  User.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    private enum Keys: String {
        case email, password
    }
    
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.email = aDecoder.decodeObject(forKey: Keys.email.rawValue) as! String
        self.password = aDecoder.decodeObject(forKey: Keys.password.rawValue) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.email, forKey: Keys.email.rawValue)
        aCoder.encode(self.password, forKey: Keys.password.rawValue)
    }
    
}
