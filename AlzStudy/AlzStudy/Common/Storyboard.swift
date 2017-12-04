//
//  StoryboardIDs.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


enum Storyboard: String {
    
    case WalkThrough
    case Registration
    case Setup
    case Today
    case Root
    
    
    func instantiate<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
        let identifier = String(describing: T.self)
        
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
