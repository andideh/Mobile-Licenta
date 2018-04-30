//
//  UIColor.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


extension UIColor {
    /**
     * Initializes and returns a color object for the given RGB hex integer.
     */
    public convenience init(rgb: Int) {
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: 1)
    }
    
    public convenience init(colorString: String) {
        var colorInt: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&colorInt)
        self.init(rgb: (Int) (colorInt))
    }
}


// Global colors

extension UIColor {
    
    static let navy = UIColor(colorString: "0C2461")
    
    static let lightGreen = UIColor(colorString: "218C74")
    
    
}
