//
//  Button.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/30/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

final class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.font = Font.futuraMedium(of: .medium)
        titleLabel?.textColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50.0)
    }
}
