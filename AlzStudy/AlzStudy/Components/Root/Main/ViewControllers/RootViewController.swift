//
//  RootViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 31/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift

final class RootViewController: UITabBarController {
    
    
    // MARK: - Private
    
    let viewModel: RootViewModelType = RootViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.viewModel.inputs.viewDidLoad()
    }
    
    static func instantiate() -> RootViewController {
        return Storyboard.Root.instantiate() as RootViewController
    }
    
    func bind() {
        self.viewModel.outputs.viewControllers
            .observeForUI()
            .observeValues { [weak self] in
                self?.viewControllers = $0
            }
    }
    
}
