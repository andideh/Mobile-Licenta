//
//  Font.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/30/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    /// 10
    case extraSmall     = 10
    /// 12
    case small          = 12
    /// 14
    case mediumSmall    = 14
    /// 16
    case medium         = 16
    /// 18
    case large          = 18
    /// 24
    case extraLarge     = 24
    /// 30
    case XXL            = 30
}


private enum FontFamily {

    enum Futura: String, FontConvertible {
        case medium = "Futura-Medium"
        case bold = "Futura-Bold"
        case italic = "Futura-MediumItalic"
    }
}

enum Font {

    static func futuraMedium(of size: FontSize) -> UIFont {
        return FontFamily.Futura.medium.font(of: size)
    }

    static func futuraBold(of size: FontSize) -> UIFont {
        return FontFamily.Futura.bold.font(of: size)
    }

    static func futuraItalic(of size: FontSize) -> UIFont {
        return FontFamily.Futura.italic.font(of: size)
    }
}


private protocol FontConvertible {
    func font(of size: FontSize) -> UIFont!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    func font(of size: FontSize) -> UIFont! {
        return UIFont(name: self.rawValue, size: size.rawValue)
    }
}
