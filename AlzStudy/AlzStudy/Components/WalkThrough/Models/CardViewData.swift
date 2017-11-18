//
//  CardViewData.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

struct CardViewData {
    let image: UIImage
    let title: String
    let description: String
    let color: UIColor
    let buttonAction: VoidBlock?
    
    init(image: UIImage, title: String, description: String, color: UIColor, buttonAction: VoidBlock? = nil) {
        self.image = image
        self.title = title
        self.description = description
        self.color = color
        self.buttonAction = buttonAction
    }
}


