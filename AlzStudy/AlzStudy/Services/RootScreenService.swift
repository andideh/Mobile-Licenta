//
//  RootScreenService.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import Firebase

final class RootScreenInitService: NSObject, UIApplicationDelegate {
    
    weak var mainWindow: UIWindow?
    
    init(with window: UIWindow?) {
        self.mainWindow = window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        let rootVC: UIViewController
        if Auth.auth().currentUser != nil {
            rootVC = ActivitiesViewController.instantiate()
        } else {
            rootVC = WalkThroughViewController.instantiate()
        }
    
        mainWindow?.rootViewController = rootVC
        mainWindow?.makeKeyAndVisible()
        
        return true
    }
    
  
}

