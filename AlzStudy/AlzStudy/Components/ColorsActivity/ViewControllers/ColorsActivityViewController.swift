//
//  ColorsActivityViewController.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/10/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let viewSize: CGFloat = 200.0
    static let spacing: CGFloat = 50.0
    static let padding: CGFloat = 16.0
}

final class ColorsActivityViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    // MARK: - Private properties

    private var tagsView: TagsView!
    private var colorView: UIView!
    private var titleLabel: UILabel!
    private let viewModel: ColorsActivityViewModelType = ColorsActivityViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputs.viewLoaded.send(value: ())
    }

    override func configureUI() {
        tagsView = TagsView()
        tagsView.delegate = self
        tagsView.translatesAutoresizingMaskIntoConstraints = false

        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = LayoutValues.viewSize / 2
        colorView.layer.shadowColor = AppStyle.Colors.lightGray.cgColor
        colorView.layer.shadowRadius = 10.0
        colorView.layer.shadowOffset = CGSize(width: 0, height: 5)
        colorView.layer.shadowOpacity = 0.5

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "The color is..."
        titleLabel.font = Font.futuraBold(of: .XXL)
    }

    override func configureLayout() {
        view.addSubview(tagsView)
        view.addSubview(colorView)
        view.addSubview(titleLabel)
        let constraints = [
            colorView.heightAnchor == LayoutValues.viewSize,
            colorView.widthAnchor == colorView.heightAnchor,
            colorView.centerXAnchor == view.centerXAnchor,
            (colorView.topAnchor == view.topAnchor) + CGFloat(150),

            tagsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutValues.padding),
            tagsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutValues.padding),
            tagsView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 50),

            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func style() {
        view.backgroundColor = .white
    }

    override func bindViewModel() {
        viewModel.outputs.displayedColor
            .observeForUI()
            .observeValues { [weak self] in
                self?.colorView.backgroundColor = $0
            }

        viewModel.outputs.answerOptions
            .observeForUI()
            .observeValues { [weak self] in
                self?.tagsView.tags = $0
            }

        viewModel.outputs.dismiss
            .observeForControllerAction()
            .observeValues { [weak self] in
                self?.dismiss(animated: true)
        }
    }

    // MARK: - Public methods

    func configure(with activity: Activity) {
        viewModel.inputs.activity.send(value: activity)
    }
    // MARK: - Private methods
}

extension ColorsActivityViewController: TagsViewDelegate {

    func didSelectItem(at index: Int) {
        viewModel.inputs.selectedItem.send(value: index)
    }
}
