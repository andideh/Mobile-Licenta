//
//  Test.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


struct Test {
    
    let type: TaskType
    let nrOfTrials: Float
    let trialsLeft: Float
    let isDone: Bool
    
    var successRate: Float {
        return trialsLeft / nrOfTrials
    }
    
    init(type: TaskType, nrOfTrials: Float = 5, trialsLeft: Float = 5, isDone: Bool = false) {
        self.type = type
        self.nrOfTrials = nrOfTrials
        self.trialsLeft = trialsLeft
        self.isDone = isDone
    }
    
    init(with json: [String:Any]) {
        let taskType = json["type"] as! Int
        
        self.type = TaskType(rawValue: taskType)!
        self.nrOfTrials = json["nrOfTrials"] as! Float
        self.trialsLeft = json["trialsLeft"] as! Float
        self.isDone = json["isDone"] as! Bool
    }

    func decrementedTrialsLeft() -> Test {
        return Test(type: self.type, nrOfTrials: self.nrOfTrials, trialsLeft: self.trialsLeft - 1.0, isDone: self.isDone)
    }
    
    func markedAsDone() -> Test {
        return Test(type: self.type, nrOfTrials: self.nrOfTrials, trialsLeft: self.trialsLeft, isDone: true)
    }
    
    func markedAsFailed() -> Test {
        return Test(type: self.type, nrOfTrials: self.nrOfTrials, trialsLeft: 0, isDone: true)
    }
}

extension Test {
    
    func toJSON() -> [String:Any] {
        return [
            "type":self.type.rawValue,
            "nrOfTrials":self.nrOfTrials,
            "trialsLeft":self.trialsLeft,
            "isDone":self.isDone
        ]
    }
}

