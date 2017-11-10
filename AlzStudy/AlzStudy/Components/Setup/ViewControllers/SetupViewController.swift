//
//  SetupViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class SetupViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public
    
    static func instantiate() -> SetupViewController {
        return Storyboard.Setup.instantiate() as SetupViewController
    }
    
    // MARK: - Private properties
    let dataSource = SetupDataSource()
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTV()
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Private methods
    fileprivate func configureTV() {
        tableView.delegate = self
        tableView.dataSource = dataSource
    }

}

extension SetupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let param = dataSource.parameters[indexPath.row]
        
        if case .gender(_) = param.type {
            showActionSheet(for: param)
        } else {
            showPopup(for: param)
        }
    }
    
    fileprivate func showPopup(for parameter: ParameterViewData) {
        let alert = UIAlertController(title: parameter.type.title, message: "Please provide the information", preferredStyle: .alert)
        
        alert.addTextField { textField in
            if parameter.isFilled {
                textField.text = parameter.type.value
            }
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            parameter.type.modify(text)
            parameter.isFilled = true
            
            self.tableView.reloadData()
        }))
        
        present(alert, animated: true)
    }
    
    fileprivate func showActionSheet(for parameter: ParameterViewData) {
        let actionSheet = UIAlertController(title: parameter.type.title, message: "Please provide the information", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Male", style: .default, handler: { _ in
            parameter.type.modify("male")
            parameter.isFilled = true
            
            self.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Female", style: .default, handler: { _ in
            parameter.type.modify("female")
            parameter.isFilled = true
            
            self.tableView.reloadData()
        }))
        
        present(actionSheet, animated: true)
    }
}
