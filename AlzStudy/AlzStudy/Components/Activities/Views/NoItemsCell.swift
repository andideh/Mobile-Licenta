//
//  NoItemsCell.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/9/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

final class NoItemsCell: UICollectionViewCell, ValueCell {

    // MARK: - Private properties

    private var textLabel: UILabel!

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(with value: Void) {
        // no-op
    }

    // MARK: - Private methods

    private func configureUI() {
        textLabel = UILabel() ~ {
            $0.textColor = AppStyle.Colors.lightGray
            $0.font = Font.futuraItalic(of: .medium)
            $0.text = Strings.Activities.noItems
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(textLabel)
        textLabel.snap(to: self)
    }

}
