//
//  NumbersViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class NumbersViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var trialsView: TrialsView!
    @IBOutlet weak var doneButton: RoundedBorderButton!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private let viewModel: NumbersTaskViewModelType = NumbersTaskViewModel()
    private var timer: Timer?
    private var countdownTimer: Timer?
    private var count: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear()
    }
    
    // MARK: - Public methods
    
    static func instantiate() -> NumbersViewController {
        return Storyboard.Numbers.instantiate() as NumbersViewController
    }
    
    func configure(test: Test) {
        self.viewModel.inputs.configure(with: test)
    }
    
    override func bindViewModel() {
        self.viewModel.outputs.hideSequenceAfterTime
            .observeForUI()
            .observeValues { [weak self] in
                after($0) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.textView.alpha = 0.0
                        self?.inputTextField.alpha = 1.0
                    }) { _ in
                        self?.viewModel.inputs.inputFieldDidAppear()
                    }
                }
            }
        
        self.viewModel.outputs.numbersSequence
            .observeForUI()
            .observeValues { [weak self] in
                self?.textView.text = $0
            }
        
        self.viewModel.outputs.updateTrialsLeft
            .observeForUI()
            .observeValues { [weak self] in
                self?.trialsView.trialsLeft = Int($0)
            }
        
        self.viewModel.outputs.startTimer
            .observeForUI()
            .observeValues { [weak self] in
                self?.startTimer($0)
            }
        
        self.viewModel.outputs.enableDoneButton
            .observeForUI()
            .observeValues { [weak self] in
                self?.doneButton.isEnabled = $0
                
                let color: UIColor = $0 ? Theme.mainColor : .lightGray
               
                self?.doneButton.borderColor = color
                self?.doneButton.setTitleColor(color, for: .normal)
            }
        
        self.viewModel.outputs.stopTimer
            .observeForUI()
            .observeValues { [weak self] in
                self?.stopTimer()
            }
        
        self.viewModel.outputs.invalidateInput
            .observeForUI()
            .observeValues { [weak self] in
                self?.inputTextField.text = nil
                self?.inputTextField.shake()
            }
        
        self.viewModel.outputs.closeScreen
            .observeForControllerAction()
            .observeValues { [weak self] in
                guard let `self` = self else { return }
                
                UIAlertController.show(message: "You have just finished the task", on: self, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        
        Keyboard.signal.observeForUI()
            .observeValues { [weak self] (change: Keyboard.Change) in
                guard let `self` = self else { return }
                
                UIView.animate(withDuration: change.duration, delay: 0.0, options: change.options, animations: {
                    self.doneButtonBottomConstraint.constant = max(20, change.frame.height)
                    self.view.layoutIfNeeded()
                })
            }
    }
    
    // MARK: - Private methods
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.viewModel.inputs.check(result: self.inputTextField.text ?? "")
    }
    
    private func startTimer(_ duration: Double) {
        self.startCountDownTimer(Int(duration))
        
        self.timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { timer in
            self.viewModel.inputs.timerDidFire()
        })
    }
    
    private func startCountDownTimer(_ duration: Int) {
        self.count = duration
        self.trialsView.timeLeft = self.count
        
        self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.count -= 1
            self.trialsView.timeLeft = self.count
        })
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
    }
}
