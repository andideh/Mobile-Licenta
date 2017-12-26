//
//  AppearanceService.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class AppearanceService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppAppearance.configureNavBarAppearance()
        
        return true
    }
}

private struct AppAppearance {
    
    static func configureNavBarAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        appearance.isTranslucent = true
    }
}
