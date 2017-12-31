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

    lazy var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    lazy var services: [UIApplicationDelegate] = {
        return [
            RootScreenInitService(with: self.window),
            FirebaseConfigService(),
            AppearanceService()
        ]
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let result = services.reduce(true) { partialResult, service in
            return partialResult && (service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true)
        }
        
        return result
    }


}

