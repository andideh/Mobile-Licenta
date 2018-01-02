//
//  LoginViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift

final class LoginViewController: BaseViewController {
    
    // MARK: - Private properties
    
    private let viewModel: LoginViewModelType = LoginViewModel()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupActions()
        self.setupDelegates()
        self.viewModel.inputs.viewDidLoad()
    }
    
    static func instantiate() -> UINavigationController {
        return Storyboard.Login.instantiateInitial() as UINavigationController
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loginButtonState
            .observeForUI()
            .observeValues { [weak self] in
                self?.loginButton.isEnabled = $0
                self?.loginButton.backgroundColor = $1
            }
        
        self.viewModel.outputs.goToMain
            .observeForControllerAction()
            .observeValues { [weak self] in
                let root = RootViewController.instantiate()
                
                self?.present(root, animated: true)
            }
        
        Keyboard.signal
            .observeForUI()
            .observeValues { [weak self] change in
                guard let `self` = self else { return }
                
                UIView.animate(withDuration: change.duration, delay: 0.0, options: change.options, animations: {
                    self.loginButtonBottomConstraint.constant = change.frame.height
                    self.view.layoutIfNeeded()
                })
            }
    }
    
    // MARK: Private methods
    
    private func setupDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    private func setupActions() {
        
        self.emailTextField.addTarget(self,
                                      action: #selector(emailTextFieldChanged(_:)),
                                      for: .editingChanged)
        
        self.passwordTextField.addTarget(self,
                                         action: #selector(passwordTextFieldChanged(_:)),
                                         for: .editingChanged)
        
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.emailChanged(textField.text ?? "")
    }
    
    @objc private func passwordTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.passwordChanged(textField.text ?? "")
    }
    
    @objc private func loginButtonTapped() {
        self.viewModel.inputs.loginButtonTapped()
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
