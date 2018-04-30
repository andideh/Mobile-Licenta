//
//  Color.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/14/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

enum Color: String {
    case red = "Red"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
    case orange = "Orange"
    case brown = "Brown"

    var uiColor: UIColor {
        switch self {
        case .red: return AppStyle.Colors.red
        case .blue: return AppStyle.Colors.blue
        case .yellow: return AppStyle.Colors.yellow
        case .orange: return AppStyle.Colors.orange
        case .brown: return AppStyle.Colors.brown
        case .green: return AppStyle.Colors.green
        }
    }
}
