//
//  RelativesViewController.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/21/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
//import ReactiveSwift

private enum LayoutValues {
    static let padding: CGFloat = 8.0
    static let cameraTopPadding: CGFloat = 20.0
    static let cameraButtonSize: CGFloat = 190.0
    static let upperContainerRatio: CGFloat = 0.6
}

final class RelativesViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    // MARK: - Private properties

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var card: UIView!
    private var circleLayer: CALayer!
    private var cameraButton: UIButton!
    private var tagView: TagsView!
    private var nextButton: UIButton!
    private var textField: LineTextField!
    private var scrollView: UIScrollView!

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tagView.tags = ["Mom", "Dad", "Sister"]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        circleLayer.frame = cameraButton.frame
        circleLayer.cornerRadius = cameraButton.bounds.height / 2
    }

    override func configureUI() {
        card = UIView.autoLayout() ~ {
            $0.backgroundColor = AppStyle.Colors.blue
        }

        descriptionLabel = UILabel.autoLayout() ~ {
            $0.font = Font.futuraMedium(of: .mediumSmall)
            $0.textColor = .white
            $0.numberOfLines = 0

            $0.text = "As a next step, you will have to provide a picture for 3 members of your family/relatives and provide a minimum amount of information about them."
        }

        titleLabel = UILabel.autoLayout() ~ {
            $0.font = Font.futuraBold(of: .XXL)
            $0.textColor = .white
            $0.text = "Relatives"
        }
        nextButton = Button.autoLayout() ~ {
            $0.backgroundColor = AppStyle.Colors.lightGray
            $0.setTitle(Strings.next, for: .normal)
        }

        cameraButton = UIButton.autoLayout() ~ {
            $0.setImage(Assets.Icons.camera, for: .normal)
            $0.backgroundColor = .clear
        }

        circleLayer = CALayer() ~ {
            $0.backgroundColor = AppStyle.Colors.lightBlue.cgColor
        }

        tagView = TagsView.autoLayout() ~ {
            $0.color = AppStyle.Colors.blue
        }

        textField = LineTextField.autoLayout() ~ {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            $0.titleText = "Name"
        }

        scrollView = UIScrollView.autoLayout()
    }

    override func configureLayout() {
        let containerView = UIView.autoLayout()
        containerView.addSubview(card)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nextButton)
        containerView.addSubview(descriptionLabel)
        containerView.layer.addSublayer(circleLayer)
        containerView.addSubview(cameraButton)
        containerView.addSubview(tagView)
        containerView.addSubview(textField)
        view.addSubview(scrollView)
        scrollView.snap(to: view)
        scrollView.addSubview(containerView)
        containerView.snap(to: scrollView)

        let constraints = [
            containerView.widthAnchor == view.widthAnchor,
            containerView.heightAnchor == view.heightAnchor,
            
            card.topAnchor == containerView.topAnchor,
            card.leadingAnchor == containerView.leadingAnchor,
            card.trailingAnchor == containerView.trailingAnchor,
            (card.heightAnchor == containerView.heightAnchor) * LayoutValues.upperContainerRatio,

            (titleLabel.topAnchor == containerView.safeTopAnchor) + 20.0,
            (titleLabel.leadingAnchor == containerView.leadingAnchor) + 16.0,
            (titleLabel.trailingAnchor == containerView.trailingAnchor) + 16.0,

            (descriptionLabel.topAnchor == titleLabel.bottomAnchor) + 16.0,
            (descriptionLabel.leadingAnchor == containerView.leadingAnchor) + 16.0,
            (descriptionLabel.trailingAnchor == containerView.trailingAnchor) - 16.0,

            (cameraButton.topAnchor == descriptionLabel.bottomAnchor) + LayoutValues.cameraTopPadding,
            cameraButton.centerXAnchor == containerView.centerXAnchor,
            cameraButton.widthAnchor == LayoutValues.cameraButtonSize,
            cameraButton.heightAnchor == LayoutValues.cameraButtonSize,

            (tagView.bottomAnchor == nextButton.topAnchor) - LayoutValues.cameraTopPadding*1.5,
            (tagView.leadingAnchor == containerView.leadingAnchor) + AppStyle.Layout.mediumPadding,
            (tagView.trailingAnchor == containerView.trailingAnchor) - AppStyle.Layout.mediumPadding,

            (textField.bottomAnchor == tagView.topAnchor) - LayoutValues.cameraTopPadding*2,
            (textField.leadingAnchor == containerView.leadingAnchor) + AppStyle.Layout.mediumPadding,
            (textField.trailingAnchor == containerView.trailingAnchor) - AppStyle.Layout.mediumPadding,

            nextButton.leadingAnchor == containerView.leadingAnchor,
            nextButton.trailingAnchor == containerView.trailingAnchor,
            nextButton.bottomAnchor == containerView.bottomAnchor
        ]
        constraints.activate()
    }

    override func style() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func bindViewModel() {

        Keyboard.signal
            .observeForUI()
            .observeValues { [weak self] change in
                guard let `self` = self else { return }

                UIView.animate(withDuration: change.duration, delay: 0.0, options: change.options, animations: {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: change.frame.height, right: 0)
                    self.scrollView.contentOffset = CGPoint(x: 0, y: change.frame.height)
                    self.view.layoutIfNeeded()
                })
        }
    }

    // MARK: - Public methods

    // MARK: - Private methods

    @objc private func textFieldDidChange(_ textfield: UITextField) {

    }

}
