//
//  BaseViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

// base implementation of view controller which calls styleUI method as part of viewDidLoad
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        bindViewModel()
    }
    
    // method to be overriden by subclasses (no need to call in viewDidLoad
    func style() {
        
    }
    
    // method to be overriden by subclasses (no need to call in viewDidLoad
    func bindViewModel() {
        
    }
}

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        bindViewModel()
    }
    
    // method to be overriden by subclasses (no need to call in viewDidLoad
    func style() {
        
    }
    
    // method to be overriden by subclasses (no need to call in viewDidLoad
    func bindViewModel() {
        
    }
    
}

