//
//  AboutYouViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class AboutYouViewController: BaseViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    lazy var agePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var heightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var weightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // MARK: - Public
    
    static func instantiate() -> AboutYouViewController {
        return Storyboard.Setup.instantiate() as AboutYouViewController
    }
    
    // MARK: - Private properties
    private let dataSource = AboutYouDataSource()
    private let viewModel: AboutYouViewModelType = AboutYouViewModel()
  
    private lazy var ageData: [Int] = {
        var data: [Int] = []
        for i in (18...99) {
            data.append(i)
        }
        return data
    }()
    
    private lazy var weightData: [Int] = {
        var data: [Int] = []
        for i in (40...200) {
            data.append(i)
        }
        return data
    }()
    
    private lazy var heightData: [Int] = {
        var data: [Int] = []
        for i in (130...200) {
            data.append(i)
        }
        return data
    }()
    
    private lazy var genderData: [String] = {
        return ["Female", "Male"]
    }()
    
    private var isSelecting: Bool = false
    
    private var currentItemIndex: Int = -1
        
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.viewModel.inputs.viewDidLoad()
    }
    
    override var canBecomeFirstResponder: Bool {
        return isSelecting
    }

    override var inputView: UIView? {
        guard isSelecting else { return nil }
        
        switch tableView.indexPathForSelectedRow?.row {
        case .some(0): return agePicker
        case .some(1): return genderPicker
        case .some(2): return heightPicker
        case .some(3): return weightPicker
        default: return nil
        }
    }
    
    override var inputAccessoryView: UIView? {
        let toolbar = ToolbarViewFactory.makeToolbar(actionTarget: self, action: #selector(doneToolbarTapped))
        return toolbar
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        viewModel.inputs.nextButtonTapped()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        
    }
    
    override func bindViewModel() {
        self.viewModel.outputs.loadForm
            .observeForUI()
            .observeValues { [weak self] in self?.dataSource.loadForm($0) }
        
        
        self.viewModel.outputs.nextButtonState
            .observeForUI()
            .observeValues { [weak self] in
                self?.nextButton.isEnabled = $0
                self?.nextButton.backgroundColor = $0 ? UIColor.red : UIColor.lightGray
        }
        
        self.viewModel.outputs.goToRegistration
            .observeForControllerAction()
            .observeValues { [weak self] in
                let registrationVC = RegistrationViewController.instantiate()
                
                self?.present(registrationVC, animated: true, completion: nil)
            }
    }
    
    @objc private func doneToolbarTapped() {
        let indexPath = IndexPath(row: self.currentItemIndex, section: 0)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.resignFirstResponder()
        
        let param = self.dataSource[IndexPath(row: self.currentItemIndex, section: 0)] as! ParameterViewData
        param.isFilled = true
        
        self.tableView.reloadData()
        
        self.viewModel.inputs.didCompleteInputForm()
    }

}

extension AboutYouViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isSelecting = true
        self.currentItemIndex = indexPath.row
        
        self.becomeFirstResponder()
        self.reloadInputViews()
    }

}
    
extension AboutYouViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView === self.agePicker) { return ageData.count }
        if (pickerView === self.weightPicker) { return weightData.count }
        if (pickerView === self.heightPicker) { return heightData.count }
        if (pickerView === self.genderPicker) { return genderData.count }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView === self.agePicker) { return String(describing: ageData[row]) }
        if (pickerView === self.weightPicker) { return String(describing: weightData[row]) }
        if (pickerView === self.heightPicker) { return String(describing: heightData[row]) }
        if (pickerView === self.genderPicker) { return genderData[row] }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value: Any
        
        if (pickerView === self.agePicker) {
            value = Int(self.ageData[row])
            
        } else if (pickerView === self.weightPicker) {
            value = Int(self.weightData[row])
            
        } else if (pickerView === self.heightPicker) {
            value = Int(self.heightData[row])
            
        } else  if (pickerView === self.genderPicker) {
            value = Gender(rawValue: row)!
            
        } else {
            fatalError()
        }
        
        self.viewModel.inputs.didSelect(value: value, forItemAtIndex: self.currentItemIndex)  
       
    }
    
    
}

