//
//  CardsFactory.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

struct CardsFactory {
    
    static func makeCards() -> [CardViewData] {
        return [
            CardViewData(image: #imageLiteral(resourceName: "health-care-2"), title: "AlzStudy", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in.", color: Theme.yellow),
            
            CardViewData(image: #imageLiteral(resourceName: "microscope"), title: "Who can participate", description: "This study is open to adults of age 18 or above.", color: Theme.navy),
            
            CardViewData(image: #imageLiteral(resourceName: "cardiogram"), title: "How the study works", description: "This app aims to use the iPhone to advance clinical research into Alzheimer's disease. AlzStudy helps you keep track of health behaviours such as physical activity, glucose level, cognitive and emotional function.", color: Theme.green),
            
            CardViewData(image: #imageLiteral(resourceName: "medical-records"), title: "", description: "", color: Theme.navy)
        ]
    }
}
