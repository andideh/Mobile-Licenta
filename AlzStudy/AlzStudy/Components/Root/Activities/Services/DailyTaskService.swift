//
//  DailyTaskService.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


struct DailyTaskService {
    
    static func makeDailyTask() -> DailyTask {
        let today = Date()
        let timestamp = dateFormatter.string(from: today)
        
        return Build(DailyTask()) {
            $0.timestamp = timestamp
            $0.tests = [
                Test(type: .memory),
                Test(type: .colors),
                Test(type: .numbers),
                Test(type: .glucose)
            ]
        }

    }
}
