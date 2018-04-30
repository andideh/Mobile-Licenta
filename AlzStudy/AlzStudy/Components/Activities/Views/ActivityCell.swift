//
//  ActivityCell.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/8/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let iconSize: CGFloat = 40.0
}

final class ActivityCell: UICollectionViewCell, ValueCell {

    typealias Value = Activity

    // MARK: - Public properties

    // MARK: - Private properties

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var iconView: UIImageView!
    private let viewModel: ActivityCellViewModelType = ActivityCellViewModel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        configureLayout()
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

    func configure(with value: Activity) {
        viewModel.inputs.configure(with: value)
    }

    // MARK: - Private methods

    private func configureUI() {
        titleLabel = UILabel() ~ {
            $0.font = Font.futuraBold(of: .mediumSmall)
            $0.textColor = UIColor.black
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        descriptionLabel = UILabel() ~ {
            $0.font = Font.futuraMedium(of: .small)
            $0.textColor = AppStyle.Colors.lightGray
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        iconView = UIImageView() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
        }

        layer.cornerRadius = 8.0
        layer.shadowColor = AppStyle.Colors.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.2

        backgroundColor = .white

//        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapped(_:)))
//        tap.minimumPressDuration = 0.02
//        self.addGestureRecognizer(tap)
    }

    @objc func tapped(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began: shrink()
        case .ended: unshrink()
        default: break
        }
    }

    private func configureLayout() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(iconView)
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppStyle.Layout.smallPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyle.Layout.mediumPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppStyle.Layout.mediumPadding),

            iconView.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: LayoutValues.iconSize),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyle.Layout.mediumPadding),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppStyle.Layout.smallPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: AppStyle.Layout.smallPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppStyle.Layout.mediumPadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyle.Layout.smallPadding)
        ]
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate(constraints)
    }

    private func bindViewModel() {
        self.viewModel.outputs.titleText
            .observeForUI()
            .observeValues { [weak self] in
                self?.titleLabel.text = $0
        }

        self.viewModel.outputs.icon
            .observeForUI()
            .observeValues { [weak self] in
                self?.iconView.image = $0
        }

        self.viewModel.outputs.detailText
            .observeForUI()
            .observeValues { [weak self] in
                self?.descriptionLabel.text = $0
        }

        self.viewModel.outputs.alpha
            .observeForUI()
            .observeValues { [weak self] in
                self?.alpha = $0
        }
    }
}
