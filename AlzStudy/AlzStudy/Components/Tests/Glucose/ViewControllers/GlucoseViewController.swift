//
//  GlucoseViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 1/12/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

final class GlucoseViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var glucoseTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    // MARK: - Private properties
    
    private let viewModel: GlucoseControllerViewModelType = GlucoseControllerViewModel()
    
    // MARK: - Lifecycle
    
    static func instantiate() -> UINavigationController {
        return Storyboard.Glucose.instantiateInitial() as UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupActions()
        self.viewModel.inputs.viewDidLoad()
    }
    
    // MARK: - Public methods
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.doneButtonState
            .observeForUI()
            .observeValues { [weak self] in
                self?.doneButton.isEnabled = $0
                self?.doneButton.backgroundColor = $1
            }
        
        self.viewModel.outputs.closeScreen
            .observeForControllerAction()
            .observeValues { [weak self] in
                self?.dismiss(animated: true)
            }
    }
    
    func configure(test: Test) {
        self.viewModel.inputs.configure(with: test)
    }
    
    // MARK: - Private methods
    
    private func setupActions() {
        self.glucoseTextField.addTarget(self, action: #selector(glucoseTextFieldChanged(_:)), for: .editingChanged)
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func glucoseTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.glucoseTextFieldChanged(textField.text)
    }
    
    @objc func doneButtonTapped() {
        self.viewModel.inputs.doneButtonTapped()
    }
    
}
