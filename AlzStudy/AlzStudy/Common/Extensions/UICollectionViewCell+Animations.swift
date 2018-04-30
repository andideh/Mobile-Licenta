//
//  UICollectionViewCell+Animations.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


extension UICollectionViewCell {
    
    func shrink() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func unshrink() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
}
