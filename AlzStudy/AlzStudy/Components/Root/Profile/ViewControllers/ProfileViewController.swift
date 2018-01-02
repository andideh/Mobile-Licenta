//
//  ProfileViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift


final class ProfileViewController: BaseViewController {
    
    
    // MARK: - Public properties
    
    @IBOutlet weak var logoutButton: RoundedBorderButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let viewModel: ProfileViewModelType = ProfileViewModel()
    private let dataSource: ProfileDataSource = ProfileDataSource()
    
    // MARK: - Lifecycle
    
    static func instantiate() -> UINavigationController {
        return Storyboard.Profile.instantiateInitial() as UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.viewModel.inputs.viewDidLoad()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.logoutButtonConfiguration
            .observeForUI()
            .observeValues { [weak self] in
                self?.logoutButton.borderColor = $0
                self?.logoutButton.setTitleColor($0, for: .normal)
            }
        
        self.viewModel.outputs.loadProfile
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.load(profile: $0)
                self?.tableView.reloadData()
            }
        
        self.viewModel.outputs.goToLoginScreen
            .observeForControllerAction()
            .observeValues { [weak self] in
                let login = LoginViewController.instantiate()
                
                self?.present(login, animated: true)
            }
    }
    
    // MARK: - Public methods
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.viewModel.inputs.logoutButtonTapped()
    }

}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
