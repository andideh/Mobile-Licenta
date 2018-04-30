//
//  LayoutHelper.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/6/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

precedencegroup CustomPrecedence {
    associativity: left
    higherThan: ModifierPrecendence
}

infix operator == : CustomPrecedence
infix operator >= : CustomPrecedence
infix operator =< : CustomPrecedence
infix operator =* : CustomPrecedence

func == (_ lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs)
}

func == (_ lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs)
}

func == (_ lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs)
}

func == (_ anchor: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    return anchor.constraint(equalToConstant: constant)
}

func == (_ lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> (CGFloat) -> NSLayoutConstraint {
    return {
        lhs.constraint(equalTo: rhs, multiplier: $0)
    }
}

func >= <T>(_ lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs)
}

func =< <T>(_ lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs)
}

func || (_ lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> (CGFloat) -> NSLayoutConstraint  {
    return { multiplier in
        return lhs.constraintEqualToSystemSpacingAfter(rhs, multiplier: multiplier)
    }
}

func || (_ lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor)  -> (CGFloat) -> NSLayoutConstraint {
    return { multiplier in
        return lhs.constraintEqualToSystemSpacingBelow(rhs, multiplier: multiplier)
    }
}

precedencegroup ModifierPrecendence {
    associativity: left
    higherThan: MultiplicationPrecedence
}
infix operator + : ModifierPrecendence
infix operator * : ModifierPrecendence
infix operator - : ModifierPrecendence

func + (_ constraint: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    constraint.constant = constant
    return constraint
}

func - (_ constraint: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    constraint.constant = -constant
    return constraint
}

func * (_ lhs: (CGFloat) -> NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
    return lhs(multiplier)
}

extension Array where Element: NSLayoutConstraint {

    func activate() {
        NSLayoutConstraint.activate(self)
    }
}

/// Extensions

extension CGRect {

    func shrinkedHeight(by constant: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height - constant)
    }
}

protocol Constraintable {
    static func autoLayout() -> Self
}

extension Constraintable where Self: UIView {
    static func autoLayout() -> Self {
        let view = Self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension UIView: Constraintable { }
