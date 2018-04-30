//
//  DailyActivity.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 3/1/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation

struct DailyActivity: Codable {
    
    let timestamp: String
    let tasks: [Activity]

    private var tasksDict: [String:Activity] {
        let keys = tasks.map { $0.type.rawValue }
        return Dictionary(uniqueKeysWithValues: zip(keys, tasks))
    }

    init(timestamp: String, tasks: [Activity]) {
        self.timestamp = timestamp
        self.tasks = tasks
    }

    enum CodingKeys: String, CodingKey {
        case tasks
        case timestamp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestamp = try container.decode(String.self, forKey: .timestamp)
        let tasksDict = try container.decode(Dictionary<String,Activity>.self, forKey: .tasks)
        let tasks = Array(tasksDict.values)
        self.init(timestamp: timestamp, tasks: tasks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(tasksDict, forKey: .tasks)
    }



}
