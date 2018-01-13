//
//  RootViewModel.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 31/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import UIKit

protocol RootViewModelInputs {
    
    func viewDidLoad()
}

protocol RootViewModelOutputs {
    
    var viewControllers: Signal<[UIViewController], NoError> { get }
    
}

protocol RootViewModelType {
    
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
    
}

final class RootViewModel: RootViewModelOutputs, RootViewModelInputs, RootViewModelType {
    
    let viewControllers: Signal<[UIViewController], NoError>
    
    init() {
        
        let activitiesVC = ActivitiesViewController.instantiate()
        let todayVC = TodayViewController.instantiate()
        let profileVC = ProfileViewController.instantiate()
        
        self.viewControllers = viewLoadedProperty.signal
            .mapConst([activitiesVC, todayVC, profileVC])
    }
        
    let viewLoadedProperty = MutableProperty<Void>(())
    func viewDidLoad() {
        self.viewLoadedProperty.value = ()
    }
    
    
    var inputs: RootViewModelInputs { return self }
    var outputs: RootViewModelOutputs { return self }
}
