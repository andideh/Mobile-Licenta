//
//  LocalStorage.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


enum Keys: String {
    case hasJoined
}

struct LocalStorage {
    
    let userDefaults = UserDefaults.standard
    
    
    func set(bool: Bool, forKey key: String) {
        userDefaults.set(bool, forKey: key)
    }
    
    func bool(for key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
}
