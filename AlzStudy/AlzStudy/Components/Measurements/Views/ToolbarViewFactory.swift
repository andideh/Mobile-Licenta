//
//  ToolBarViewFactory.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 03/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


struct ToolbarViewFactory {
    
    static func makeToolbar(actionTarget target: Any, action: Selector) -> UIToolbar {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0)
        let toolbar = UIToolbar(frame: frame)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: action)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.tintColor = .gray
        toolbar.items = [space, doneButton]
        
        return toolbar
    }
}
