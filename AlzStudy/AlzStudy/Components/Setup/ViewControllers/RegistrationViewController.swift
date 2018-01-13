//
//  RegistrationViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 03/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class RegistrationViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registrationButton: UIButton!
    
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private var viewModel: RegistrationViewModelType = RegistrationViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDelegates()
        self.setupActions()
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override var canBecomeFirstResponder: Bool { return false }
    override var inputAccessoryView: UIView? { return nil }
    
    
    // MARK: - IBActions
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.viewModel.inputs.registerButtonTapped()
    }
    
    // MARK: - Public methods
    
    static func instantiate() -> RegistrationViewController {
        return Storyboard.Setup.instantiate() as RegistrationViewController
    }
    
    override func bindViewModel() {
        self.viewModel.outputs.isRegisterButtonEnabled
            .observeForUI()
            .observeValues { [weak self] in
                self?.registrationButton.isEnabled = $0
                self?.registrationButton.backgroundColor = $0 ? Theme.mainColor : UIColor.lightGray
            }
        
        self.viewModel.outputs.signIn
            .observeForControllerAction()
            .observeValues { [weak self] in
                let todayVC = TodayViewController.instantiate()
                
                self?.present(todayVC, animated: true)
            }
    }
    
    // MARK: - Private methods
    
    private func setupDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    private func setupActions() {
        
        self.emailTextField.addTarget(self,
                                      action: #selector(emailTextFieldChanged(_:)),
                                      for: .editingChanged)

        self.passwordTextField.addTarget(self,
                                      action: #selector(passwordTextFieldChanged(_:)),
                                      for: .editingChanged)
        
        self.confirmPasswordTextField.addTarget(self,
                                      action: #selector(confirmPasswordTextFieldChanged(_:)),
                                      for: .editingChanged)
    }
    
    
    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.emailChanged(textField.text ?? "")
    }
    
    @objc private func passwordTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.passwordChanged(textField.text ?? "")
    }
    
    @objc private func confirmPasswordTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.confirmPasswordChanged(textField.text ?? "")
    }
}


extension RegistrationViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
