//
//  AppDelegate.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/3/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if !LocalStorage().bool(for: Keys.hasJoined.rawValue) {
            let walkThrough = WalkThroughViewController.instantiate()
            window?.rootViewController = walkThrough
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

  


}

