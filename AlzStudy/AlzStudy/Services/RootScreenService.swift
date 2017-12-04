//
//  RootScreenService.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class RootScreenInitService: NSObject, UIApplicationDelegate {
    
    weak var mainWindow: UIWindow?
    
    init(with window: UIWindow?) {
        self.mainWindow = window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
//        AppearanceConfigurator.configureGlobalAppearance()
        
        if AppEnvironment.current.currentUser == nil {
            let walkThrough = WalkThroughViewController.instantiate()
            
            mainWindow?.rootViewController = walkThrough
        } else {
            // TODO: navigate to
        }
        

            
        mainWindow?.makeKeyAndVisible()
        
        return true
    }
    
}
