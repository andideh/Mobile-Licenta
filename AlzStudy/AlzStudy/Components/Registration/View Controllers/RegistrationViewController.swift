//
//  RegistrationViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol RegistrationViewControllerProtocol: AnyObject {
    func didSignup()
}

final class RegistrationViewController: UIViewController {
    
    // MARK: - public properties
    weak var delegate: RegistrationViewControllerProtocol?

    
    static func instantiate() -> RegistrationViewController {
        return Storyboard.Registration.instantiate() as RegistrationViewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    // MARK: - VC lifecycle
    
    
    // MARK: - IBActions
    
    
    // MARK: - Private methods
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        delegate?.didSignup()
    }
    

}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
