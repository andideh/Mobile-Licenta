//
//  TabBar.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/8/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let indicatorBarHeight: CGFloat = 4.0
    static let indicatorBarWidth: CGFloat = 80.0
    static let tabBarIntrinsicHeight: CGFloat = 55.0
    static let buttonWidth: CGFloat = 44.0
    static let buttonsAreaHeight: CGFloat = LayoutValues.tabBarIntrinsicHeight - LayoutValues.indicatorBarHeight
}

protocol TabBarDelegate: AnyObject {
    var numberOfTabs: Int { get }

    func imageForTab(at index: Int) -> UIImage
    func didTapItem(at index: Int)
}

final class TabBar: UIView {

    // MARK: - Public properties

    // MARK: - Private properties

    private unowned var delegate: TabBarDelegate
    private var buttons: [UIButton] = []
    private var indicator: CALayer!

    // MARK: - Lifecycle

    init(with delegate: TabBarDelegate) {
        self.delegate = delegate

        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: LayoutValues.tabBarIntrinsicHeight)
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        indicator.position.x = buttons[0].frame.midX
    }
    // MARK: - Public methods

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .white

        for index in 0..<delegate.numberOfTabs {
            let button = makeTabButton(at: index)
            buttons.append(button)
        }

        indicator = CALayer() ~ {
            $0.frame = CGRect(x: 0, y: LayoutValues.buttonsAreaHeight, width: LayoutValues.indicatorBarWidth, height: LayoutValues.indicatorBarHeight)
            $0.backgroundColor = AppStyle.Colors.darkGreen.cgColor
        }

        layer.shadowColor = AppStyle.Colors.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        layer.shadowRadius = 7.5
        layer.shadowOpacity = 0.15
    }

    private func configureLayout() {
        layer.addSublayer(indicator)
        buttons.forEach { addSubview($0) }

        var index: Float = 1
        let count = Float(buttons.count)
        var constraints: [NSLayoutConstraint] = []
        for button in buttons {
            constraints +=  [button.widthAnchor == LayoutValues.buttonWidth,
                             button.heightAnchor == LayoutValues.buttonsAreaHeight,
                             (button.centerYAnchor || self.centerYAnchor) * CGFloat(1.0)]
            constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerX, multiplier: CGFloat(index/count), constant: 0))

            index += 2
        }
        NSLayoutConstraint.activate(constraints)
    }

    private func makeTabButton(at index: Int) -> UIButton {
        let button = UIButton() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
            let image = delegate.imageForTab(at: index)
            $0.setImage(image, for: .normal)
            $0.tintColor = AppStyle.Colors.lightGray
            $0.tag = index
            $0.addTarget(self, action: #selector(didTapOn(button:)), for: .touchUpInside)
        }
        return button
    }

    @objc private func didTapOn(button: UIButton) {
        delegate.didTapItem(at: button.tag)
        indicator.position.x = button.frame.midX
    }
}
