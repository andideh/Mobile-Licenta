//
//  Auth.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

struct Auth {
    
    var isAuthenticated: Bool {
        
        if let data = UserDefaults.standard.object(forKey: "user") as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User{
            AppEnvironment.pushEnvironment(currentUser: user)
            
            return true
        }
        
        return false
    }
}


class User: NSObject, NSCoding {
    
    private enum Keys: String {
        case name, email, password
    }
    
    let name: String
    let email: String
    let password: String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as! String
        self.email = aDecoder.decodeObject(forKey: Keys.email.rawValue) as! String
        self.password = aDecoder.decodeObject(forKey: Keys.password.rawValue) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: Keys.name.rawValue)
        aCoder.encode(self.email, forKey: Keys.email.rawValue)
        aCoder.encode(self.password, forKey: Keys.password.rawValue)
    }
    
}
