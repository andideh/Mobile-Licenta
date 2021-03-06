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
    private var role: UserRole!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupActions()
        
        self.viewModel.inputs.viewDidLoad()
        self.viewModel.inputs.userRole(self.role)
    }
    
    override var canBecomeFirstResponder: Bool { return false }
    override var inputAccessoryView: UIView? { return nil }
    
    
    // MARK: - IBActions
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.viewModel.inputs.registerButtonTapped()
    }
    
    // MARK: - Public methods
    
    static func instantiate(with role: UserRole) -> UINavigationController {
        let navController = Storyboard.Registration.instantiateInitial() as UINavigationController
        let registrationViewController = navController.viewControllers.first as! RegistrationViewController
        
        registrationViewController.role = role
        
        return navController
    }
    
    override func bindViewModel() {
        self.viewModel.outputs.registerButtonState
            .observeForUI()
            .observeValues { [weak self] in
                self?.registrationButton.isEnabled = $0.0
                self?.registrationButton.backgroundColor = $0.1
            }
        
        self.viewModel.outputs.signInAsPatient
            .observeForControllerAction()
            .observeValues { [weak self] in
                let measurementsVC = embedInNavigation(controller: MeasurementsViewController())
                measurementsVC.modalTransitionStyle = .crossDissolve
                self?.present(measurementsVC, animated: true)
            }
        
        self.viewModel.outputs.signInAsDoctor
            .observeForControllerAction()
            .observeValues {
                print("i am a doctor")
            }
        
        Keyboard.signal.observeForUI()
            .observeValues { [weak self] change  in
                guard let `self` = self else { return }
                
                UIView.animate(withDuration: change.duration, delay: 0.0, options: change.options, animations: {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: change.frame.height, right: 0)
                    self.view.layoutIfNeeded()
                })
            }
    }

    // MARK: - Private methods
    
    private func setupActions() {
        
        self.fullNameTextField.addTarget(self,
                                         action: #selector(fullNameTextFieldChanged(_:)),
                                         for: .editingChanged)
        
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
    
    @objc private func fullNameTextFieldChanged(_ textfield: UITextField) {
        self.viewModel.inputs.fullNameChanged(textfield.text ?? "")
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
