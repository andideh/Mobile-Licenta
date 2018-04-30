//
//  UIResponder+Extension.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func findResponder<T>() -> T? {
        var responder: UIResponder! = self
        
        while responder != nil {
            if let responder = responder as? T {
                return responder
            }
            
            responder = responder.next
        }
        
        return nil
    }
}

