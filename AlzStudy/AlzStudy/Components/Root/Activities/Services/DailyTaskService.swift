//
//  DailyTaskService.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 24/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

protocol ServiceType {
    
    func fetchTodayTask() -> SignalProducer<DailyTask, ASError>
    func fetchYesterdayTask() -> SignalProducer<DailyTask, ASError>
}

class MockService: ServiceType {
 
    func fetchTodayTask() -> SignalProducer<DailyTask, ASError> {
        let producer = SignalProducer<DailyTask, ASError> { observer, _ in
                after(0.5) {
                    observer.send(error: ASError.noTodayTask)
                }
            }
            .flatMapError { (error: ASError) -> SignalProducer<DailyTask, ASError> in
                
                print("Entered flatMapError: \(error)")
                
                switch error {
                case .jsonParseError: return .init(error: error)
                case .noTodayTask: return self.createTodayTask()
                }
            }
        
        return producer
    }
    
    func fetchYesterdayTask() -> SignalProducer<DailyTask, ASError> {
        return SignalProducer<DailyTask, ASError> { observer, _ in
            after(1.0) {
                let dailyTask = DailyTaskFactory.makeDoneDailyTask()
                
                observer.send(value: dailyTask)
                observer.sendCompleted()
            }
        }
    }
    
    private func createTodayTask() -> SignalProducer<DailyTask, ASError> {
        return SignalProducer<DailyTask, ASError> { observer, _ in
            after(0.5) {
                let dailyTask = DailyTaskFactory.makeNewDailyTask()
                
                observer.send(value: dailyTask)
                observer.sendCompleted()
            }
        }
    }
}

private struct DailyTaskFactory {
   
    static func makeNewDailyTask() -> DailyTask {
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
    
    static func makeDoneDailyTask() -> DailyTask {
        let now = Date()
        let yesterday = now.addingTimeInterval( -60 * 60 * 20)
        
        let timestamp = dateFormatter.string(from: yesterday)
        
        return Build(DailyTask(), block: {
            $0.timestamp = timestamp
            $0.tests = [
                Test(type: .memory, nrOfTrials: 5, trialsLeft: 3, isDone: true),
                Test(type: .colors, nrOfTrials: 5, trialsLeft: 2, isDone: true),
                Test(type: .numbers, nrOfTrials: 5, trialsLeft: 5, isDone: true),
                Test(type: .glucose, nrOfTrials: 5, trialsLeft: 4, isDone: true)
            ]
        })
    }
}
