//
//  Keyboard.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

final class Keyboard {
    typealias Change = (frame: CGRect, duration: TimeInterval, options: UIViewAnimationOptions, notificationName: Notification.Name)
    
    static let shared = Keyboard()
    
    private let (changeSignal, changeObserver) = Signal<Change, NoError>.pipe()
    
    static var signal: Signal<Change, NoError> {
        return self.shared.changeSignal
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(change(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(change(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func change(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIViewAnimationCurve(rawValue: curveNumber.intValue)
            else {
                return
        }
        
        let value: Change = (frame: frame.cgRectValue, duration: duration.doubleValue, options: UIViewAnimationOptions(rawValue: UInt(curve.rawValue)), notificationName: notification.name)

        self.changeObserver.send(value: value)
    }
}
