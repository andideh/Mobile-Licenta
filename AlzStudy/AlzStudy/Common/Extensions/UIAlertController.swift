//
//  UIAlertController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func show(message: String, on vc: UIViewController, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        
        vc.present(alert, animated: true)
    }
}
