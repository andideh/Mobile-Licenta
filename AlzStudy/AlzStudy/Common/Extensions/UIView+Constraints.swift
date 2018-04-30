//
//  UIView+Constraints.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/6/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

extension UIView {

    func snap(to parent: UIView, inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: parent.topAnchor, constant: inset.top),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -inset.right),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -inset.bottom),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset.left)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }

    
}
