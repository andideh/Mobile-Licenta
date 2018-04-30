//
//  AppStyle.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/30/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

enum AppStyle {


    enum Colors {
        static let lightGray = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        /// 218C74
        static let darkGreen = #colorLiteral(red: 0.1294117647, green: 0.5490196078, blue: 0.4549019608, alpha: 1)
        static let yellow = UIColor(colorString: "fed330")
        static let navy = UIColor(colorString: "2980b9")
//        static let red = UIColor(colorString: "d35400")
        static let red = UIColor(colorString: "eb2f06")
        static let gradientStart = UIColor(colorString: "257BD2")
        static let gradientEnd = UIColor(colorString: "50EDCF")

        static let shadow = UIColor.black.withAlphaComponent(0.1)

        static let green = UIColor(colorString: "26de81")
        static let brown = UIColor(colorString: "CA6924")
        static let blue = UIColor(colorString: "4990e2")
        static let orange = UIColor(colorString: "F9690E")

        static let lightBlue = UIColor(colorString: "68A0E0")
        static let darkNavy = UIColor(colorString: "0C2461")
    }

    enum Layout {
        static let mediumPadding: CGFloat = 16.0
        static let smallPadding: CGFloat = 8.0
    }
}


