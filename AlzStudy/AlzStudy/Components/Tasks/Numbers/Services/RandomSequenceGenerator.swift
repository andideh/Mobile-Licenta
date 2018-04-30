//
//  RandomSequenceGenerator.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


struct RandomSequenceGenerator {
    
    static func generate(_ count: Int = 8) -> [Int] {
        var sequence = [Int]()
        
        for _ in 0..<count {
            let randomNumber = Int(arc4random_uniform(9))
            sequence.append(randomNumber)
        }
        
        return sequence
    }
}
