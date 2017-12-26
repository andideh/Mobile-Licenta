//
//  Protocols.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String { return String(describing: self) }
}


protocol Shakeable {

    func shake()
}

extension Shakeable where Self: UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.fromValue = CGPoint(x: self.center.x + 5, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x - 5, y: self.center.y)
        animation.duration = 0.1
        animation.repeatCount = 3
        
        self.layer.add(animation, forKey: "shake")
    }
}


extension UITextField: Shakeable { }
