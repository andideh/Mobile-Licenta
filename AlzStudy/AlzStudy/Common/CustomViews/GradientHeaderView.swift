//
//  GradientHeaderView.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/6/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let spacing: CGFloat = 8.0
}

final class GradientHeaderView: UIView {

    // MARK: - Public properties

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    var detailText: String? {
        didSet {
            if let text = detailText {
                detailLabel.text = text
                detailLabel.isHidden = false
            } else {
                detailLabel.isHidden = true
            }
        }
    }

    // MARK: - Private properties

    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var stackView: UIStackView!
    private var gradientLayer: CAGradientLayer!
    private var darkOverlay: CALayer!

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        backgroundColor = AppStyle.Colors.navy
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        darkOverlay.frame = bounds
    }

    // MARK: - Private methods

    private func configureUI() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [AppStyle.Colors.gradientStart.cgColor, AppStyle.Colors.gradientEnd.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        darkOverlay = CALayer()
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = Font.futuraBold(of: .extraLarge)

        detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.textColor = .white
        detailLabel.numberOfLines = 0
        detailLabel.font = Font.futuraMedium(of: .small)
        detailLabel.isHidden = true

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = LayoutValues.spacing
    }

    private func configureLayout() {
        layer.addSublayer(gradientLayer)
        layer.addSublayer(darkOverlay)
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)

        stackView.snap(to: self, inset: UIEdgeInsets(top: AppStyle.Layout.mediumPadding + 20.0, left: AppStyle.Layout.mediumPadding, bottom: AppStyle.Layout.mediumPadding, right: AppStyle.Layout.mediumPadding))
    }
}
