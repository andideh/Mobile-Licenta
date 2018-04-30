//
//  MeasurementCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let iconSize: CGFloat = 25.0
    static let padding: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 12.0, right: 8.0)
}

final class MeasurementCell: UICollectionViewCell, ValueCell {
    
    typealias Value = ParameterViewData

    // MARK: - Private properties

    /// outlets
    private var iconView: UIImageView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!

    private var viewModel: MeasurementCellViewModelType = MeasurementCellViewModel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    // MARK: - Public methods

    func configure(with value: ParameterViewData) {
        self.viewModel.inputs.configure(with: value)
    }
   
    // MARK: - Private methods

    private func configureUI() {
        iconView = UIImageView() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
        }

        titleLabel = UILabel() ~ {
            $0.font = Font.futuraMedium(of: .large)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
        }

        detailLabel = UILabel() ~ {
            $0.font = Font.futuraItalic(of: .medium)
            $0.textColor = AppStyle.Colors.lightGray
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
        }

        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        let constraints = [
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutValues.padding.left),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: LayoutValues.iconSize),
            iconView.heightAnchor.constraint(equalTo: iconView.heightAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: AppStyle.Layout.mediumPadding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: AppStyle.Layout.smallPadding),
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutValues.padding.right),
        ]
        NSLayoutConstraint.activate(constraints)

        layer.shadowColor = AppStyle.Colors.shadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4.5
        layer.cornerRadius = 5.0
        layer.shadowOpacity = 1.0

        backgroundColor = .white
    }
    
    private func bindViewModel() {
        self.viewModel.outputs.titleText
            .observeForUI()
            .observeValues { [weak self] in self?.titleLabel.text = $0 }
        
        self.viewModel.outputs.icon
            .observeForUI()
            .observeValues { [weak self] in self?.iconView.image = $0 }

        self.viewModel.outputs.detailText
            .observeForUI()
            .observeValues { [weak self] in self?.detailLabel.text = $0 }
    }
}


   
