//
//  LocalStorage.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


enum Key: String {
    case hasJoined
    case isLoggedIn
    case hasSeenWalkthrough
    case isDoctor 
}

// Generic interface for a service which stores info on device local storage
protocol LocalStorageType {
    func set(bool: Bool, forKey key: Key)
    func bool(for key: Key) -> Bool 
}

struct UserDefaultsLocalStorage: LocalStorageType {
    
    let userDefaults = UserDefaults.standard
    
    func set(bool: Bool, forKey key: Key) {
        userDefaults.set(bool, forKey: key.rawValue)
    }
    
    func bool(for key: Key) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
}
