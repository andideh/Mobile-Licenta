//
//  ParticipantsViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 14/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift


final class ParticipantsViewController: BaseViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Private properties
    
    private let viewModel: ParticipantsViewModelType = ParticipantsViewModel()
    private let dataSource = ParticipantsDataSource()
    
    // MARK: - Lifecycle
    
    static func instantiate() -> UINavigationController {
        return Storyboard.Participants.instantiateInitial() as UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    // MARK: - Public methods
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadParticipants
            .observeForUI()
            .observeValues { [weak self] participants in
                let names = participants.map { $0.fullName }
               
                self?.dataSource.load(participants: names)
                self?.tableView.reloadData()
            }
        
        self.viewModel.outputs.goToLogin
            .observeForControllerAction()
            .observeValues { [weak self] in
                let login = LoginViewController.instantiate()
                
                self?.present(login, animated: true)
            }
    }
    
    // MARK: - Private methods
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.viewModel.inputs.logoutButtonTapped()
    }
    
}


extension ParticipantsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
}
