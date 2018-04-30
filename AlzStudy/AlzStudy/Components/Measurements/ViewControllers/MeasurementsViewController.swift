//
//  MeasurementsViewController.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/30/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let innerPadding: CGFloat = 24.0
    static let buttonHeight: CGFloat = 50.0
    static let rowHeight: CGFloat = 64.0
    static let rowWidth: CGFloat = 0.9 * screenWidth
    static let lineSpacing: CGFloat = 24.0
}

final class MeasurementsViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    // MARK: - Private properties

    /// outlets
    private var infoLabel: UILabel!
    private var nextButton: UIButton!
    private var collectionView: UICollectionView!
    private lazy var agePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var heightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var weightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private let viewModel: MeasurementsViewModelType = MeasurementsViewModel()
    private let dataSource = MeasurementsDataSource()
    private var currentItemIndex: Int = -1
    private var isSelecting: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Strings.Measurements.title
        viewModel.inputs.viewDidLoad()
    }

    override var inputView: UIView? {
        guard isSelecting else { return nil }

        switch collectionView.indexPathsForSelectedItems?.first?.item {
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

    override var canBecomeFirstResponder: Bool {
        return isSelecting
    }

    // MARK: - Config

    override func configureUI() {
        infoLabel = UILabel() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
        }

        nextButton = Button() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(Strings.next, for: .normal)
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self.dataSource
            $0.contentInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
            $0.allowsMultipleSelection = false
        }

        dataSource.registerClasses(collectionView: collectionView)
    }

    override func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(collectionView)
        view.addSubview(nextButton)

        let constraints = [
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyle.Layout.smallPadding),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyle.Layout.mediumPadding),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppStyle.Layout.mediumPadding),

            collectionView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: LayoutValues.innerPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor),

            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: LayoutValues.buttonHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func style() {
        view.backgroundColor = .white

        infoLabel.font = Font.futuraMedium(of: .mediumSmall)
        infoLabel.textColor = AppStyle.Colors.lightGray
    }

    override func bindViewModel() {
        self.viewModel.outputs.loadForm
            .observeForUI()
            .observeValues { [weak self] in self?.dataSource.loadForm($0) }

        self.viewModel.outputs.nextButtonState
            .observeForUI()
            .observeValues { [weak self] in
                self?.nextButton.isEnabled = $0
                self?.nextButton.backgroundColor = $0 ? AppStyle.Colors.darkGreen : AppStyle.Colors.lightGray
        }

        self.viewModel.outputs.goToNext
            .observeForControllerAction()
            .observeValues { [weak self] in
                let root = RootViewController()
                root.modalTransitionStyle = .crossDissolve
                self?.present(root, animated: true, completion: nil)
        }

        viewModel.outputs.disclaimer.observeForUI()
            .observeValues { [weak self] in self?.infoLabel.text = $0 }
    }

    // MARK: - Private methods

    @objc private func doneToolbarTapped() {
        let indexPath = IndexPath(row: currentItemIndex, section: 0)
        collectionView.deselectItem(at: indexPath, animated: true)
        resignFirstResponder()

        collectionView.reloadData()
        viewModel.inputs.didCompleteInputForm()
    }

    @objc private func nextButtonTapped() {
        viewModel.inputs.nextButtonTapped()
    }

}

extension MeasurementsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelecting = true
        currentItemIndex = indexPath.row
        becomeFirstResponder()
        reloadInputViews()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LayoutValues.rowWidth, height: LayoutValues.rowHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutValues.lineSpacing
    }
}

extension MeasurementsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView === agePicker) { return viewModel.outputs.ageData.count }
        if (pickerView === weightPicker) { return viewModel.outputs.weightData.count }
        if (pickerView === heightPicker) { return viewModel.outputs.heightData.count }
        if (pickerView === genderPicker) { return viewModel.outputs.genderData.count }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView === agePicker) { return viewModel.outputs.ageData[row].toString() }
        if (pickerView === weightPicker) { return viewModel.outputs.weightData[row].toString() }
        if (pickerView === heightPicker) { return viewModel.outputs.heightData[row].toString() }
        if (pickerView === genderPicker) { return viewModel.outputs.genderData[row] }

        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let param = dataSource[IndexPath(item: self.currentItemIndex, section: 0)] as! ParameterViewData
        let value: Any
        if (pickerView === agePicker) {
            value = Int(viewModel.outputs.ageData[row])
            viewModel.inputs.didSelect(value: value, for: .age)
            param.type = .age(value as! Int)
        } else if (pickerView === weightPicker) {
            value = Int(viewModel.outputs.weightData[row])
            viewModel.inputs.didSelect(value: value, for: .weight)
            param.type = .weight(value as! Int)
        } else if (pickerView === heightPicker) {
            value = Int(viewModel.outputs.heightData[row])
            viewModel.inputs.didSelect(value: value, for: .height)
            param.type = .height(value as! Int)
        } else  if (pickerView === genderPicker) {
            value = Gender(rawValue: row)!
            viewModel.inputs.didSelect(value: value, for: .gender)
            param.type = .gender(value as! Gender)
        } else {
            fatalError()
        }
    }
}
