//
//  Test.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation


struct Test {
    
    let type: ActivityType
    let nrOfTrials: Float
    let trialsLeft: Float
    let isDone: Bool
    let metadata: String?
    
    var successRate: Float {
        return trialsLeft / nrOfTrials
    }
    
    init(type: ActivityType, nrOfTrials: Float = 5, trialsLeft: Float = 5, isDone: Bool = false, metadata: String? = nil) {
        self.type = type
        self.nrOfTrials = nrOfTrials
        self.trialsLeft = trialsLeft
        self.isDone = isDone
        self.metadata = metadata
    }
    
    init(with json: [String:Any]) {
        let taskType = json["type"] as! String
        
        self.type = ActivityType(rawValue: taskType)!
        self.nrOfTrials = json["nrOfTrials"] as! Float
        self.trialsLeft = json["trialsLeft"] as! Float
        self.isDone = json["isDone"] as! Bool
        self.metadata = json["metadata"] as? String
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
    
    func adding(metadata: String) -> Test {
        return Test(type: self.type, nrOfTrials: self.nrOfTrials, trialsLeft: self.trialsLeft, isDone: self.isDone, metadata: metadata)
    }
}

extension Test {
    
    func toJSON() -> [String:Any] {
        var json: [String:Any] =  [
            "type":self.type.rawValue,
            "nrOfTrials":self.nrOfTrials,
            "trialsLeft":self.trialsLeft,
            "isDone":self.isDone
        ]
        
        if let metadata = metadata {
            json["metadata"] = metadata
        }

        return json
    }
}

