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
        
//        if Auth.auth().currentUser != nil {
//            if AppEnvironment.current.localStorage.bool(for: Key.isDoctor) {
//                rootVC = ParticipantsViewController.instantiate()
//            } else {
//                AppEnvironment.replaceCurrentEnvironment(currentUser: CurrentUser(firUser: Auth.auth().currentUser!, role: .participant))
//                rootVC = RootViewController()
//            }
//        } else if AppEnvironment.current.localStorage.bool(for: Key.hasJoined) {
//            rootVC = LoginViewController.instantiate()
//        } else {
//            rootVC = WalkThroughViewController.instantiate()
//        }

        
        // TBD: Only for development

        ////// Registration flow
//        let reg = RegistrationViewController.instantiate(with: .participant)
//        rootVC = reg

        ////// Measurements flow
//        let currentUser = CurrentUser(firUser: nil, role: .participant)
//        AppEnvironment.replaceCurrentEnvironment(currentUser: currentUser)
//        let viewModel = MeasurementsViewModel()
//        let vc = MeasurementsViewController()
//        let measureVC = embedInNavigation(controller: vc)

//        rootVC = measureVC

        ////// Activities

//        let activities = ActivitiesViewController()


        ////// TabController
//        rootVC = TabBarController(with: [activities, measureVC, reg])

//        rootVC = NumbersViewController.instantiate()
//        (rootVC as! NumbersViewController).configure(task: Activity(type: .numbers))

//        rootVC = ColorsActivityViewController()
//        (rootVC as! ColorsActivityViewController).configure(with: Activity(type: .colors))

        rootVC = RelativesViewController()

//        rootVC = ProgressViewController()

        mainWindow?.rootViewController = rootVC
        mainWindow?.makeKeyAndVisible()
        
        return true
    }
    
  
}

