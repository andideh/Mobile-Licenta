//
//  FirebaseConfigService.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/22/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseConfigService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        return true
    }
}
