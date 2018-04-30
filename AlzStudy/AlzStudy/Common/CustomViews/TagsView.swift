//
//  TagsView.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/10/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

typealias Tag = String

private enum LayoutValues {
    static let intrinsicHeight: CGFloat = 64.0
    static let topPadding: CGFloat = 20.0
    static let marginPadding: CGFloat = 50.0
    static let spacing: CGFloat = 20.0
}

protocol TagsViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

final class TagsView: UIView {

    // MARK: - Public properties

    var tags: [Tag] = [] {
        didSet {
            removeExistingTags()
            configureTags()
        }
    }

    var delegate: TagsViewDelegate?
    var color: UIColor = AppStyle.Colors.navy

    // MARK: - Private properties

    private var tagViews: [UIButton] = []
    private let scrollview = UIScrollView()


    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: LayoutValues.intrinsicHeight)
    }

    // MARK: - Public methods

    // MARK: - Private methods

    private func configureUI() {
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollview)
        scrollview.snap(to: self)
    }

    private func configureTags() {
        let font = Font.futuraMedium(of: .mediumSmall)
        let attributes = [NSAttributedStringKey.font: font]
        var xPosition: CGFloat = 8.0
        for (index, tag) in tags.enumerated() {
            let button = UIButton()
            let boundedText = (tag as NSString).size(withAttributes: attributes)
            let frame = CGRect(x: xPosition, y: LayoutValues.topPadding/2, width: boundedText.width + LayoutValues.marginPadding, height: LayoutValues.intrinsicHeight - LayoutValues.topPadding)
            button.frame = frame
            button.layer.cornerRadius = frame.height / 2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = color.cgColor
            let attributedText = NSAttributedString(string: tag, attributes: [
                NSAttributedStringKey.font: font,
                NSAttributedStringKey.foregroundColor: color
                ])
            button.setAttributedTitle(attributedText, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

            xPosition += LayoutValues.spacing + button.frame.width

            tagViews.append(button)
        }
        let width = max(xPosition, UIScreen.main.bounds.width)
        scrollview.contentSize = CGSize(width: width, height: LayoutValues.intrinsicHeight)
        tagViews.forEach { self.scrollview.addSubview($0) }

        if scrollview.contentSize.width <= UIScreen.main.bounds.width {
            let offset = (UIScreen.main.bounds.width - xPosition) / 2
            scrollview.contentInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
            scrollview.contentOffset = CGPoint(x: -offset, y: 0)
            scrollview.isScrollEnabled = false
        } else {
            scrollview.contentInset = .zero
            scrollview.contentOffset = .zero
            scrollview.isScrollEnabled = true
        }
    }

    private func removeExistingTags() {
        tagViews.removeAll()
        for view in scrollview.subviews where view is UIButton {
            view.removeFromSuperview()
        }
    }

    @objc private func buttonTapped(_ button: UIButton) {
        button.backgroundColor = color
        let text = button.titleLabel?.text ?? ""
        let attributes: [NSAttributedStringKey:Any] = [
            NSAttributedStringKey.font: Font.futuraMedium(of: .mediumSmall),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)

        let currentlySelectedButton = tagViews.filter { $0.isSelected }.first
        if let button = currentlySelectedButton {
            button.backgroundColor = .clear
            let text = button.titleLabel?.text ?? ""
            let attributes: [NSAttributedStringKey:Any] = [
                NSAttributedStringKey.font: Font.futuraMedium(of: .mediumSmall),
                NSAttributedStringKey.foregroundColor: color
            ]
            let attributedTitle = NSAttributedString(string: text, attributes: attributes)
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.isSelected = false
        }
        button.isSelected = true

        delegate?.didSelectItem(at: button.tag)
    }
}
