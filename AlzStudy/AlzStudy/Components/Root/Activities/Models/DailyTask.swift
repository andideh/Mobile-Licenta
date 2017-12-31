//
//  DailyTask.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import Firebase


class DailyTask {

    var timestamp: String = ""
    var isDone: Bool = false
    var tests: [Test] = []
    
    init() { }
    
    init?(with snapshot: DataSnapshot) {
        guard let json = snapshot.value as? [String:Any] else { return nil }
        guard let testJson = json["tests"] as? [[String:Any]] else { return nil }
        
        self.timestamp = json["timestamp"] as! String
        self.isDone = json["isDone"] as! Bool
        self.tests = testJson.flatMap { Test.init(with: $0) }
    }
    
}

extension DailyTask {
    
    func toJSON() -> [String:Any] {
        let testJSON = self.tests.map { $0.toJSON() }
        let keys = self.tests.map { String(describing: $0.type.rawValue) }
        let dict = Dictionary(uniqueKeysWithValues: zip(keys, testJSON))
        
        return [
            "timestamp": self.timestamp,
            "isDone": self.isDone,
            "tests": dict
        ]
    }
}
