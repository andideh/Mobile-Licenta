//
//  ActivitiesDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


final class ActivitiesDataSource: ValueCellDataSource {
    
    private enum Sections: Int {
        case today
        case todayTasks
        case yesterday
        case yesterdayTasks
    }
    
    
    func loadTodayTasks(_ tasks: [TaskCellViewData]) {
        self.set(values: ["Today"], cellClass: DateCell.self, inSection: Sections.today.rawValue)
        
        self.set(values: tasks, cellClass: TaskCell.self, inSection: Sections.todayTasks.rawValue)
    }
    
    func loadYesterdayTasks(_ tasks: [TaskCellViewData]) {
        self.set(values: ["Yesterday"], cellClass: DateCell.self, inSection: Sections.yesterday.rawValue)
        
        self.set(values: tasks, cellClass: TaskCell.self, inSection: Sections.yesterdayTasks.rawValue)
    }
    
    override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        
        case (let cell as DateCell, let value as String): cell.configure(with: value)
        case (let cell as TaskCell, let value as TaskCellViewData): cell.configure(with: value)
            
        default: fatalError()
        }
    }
    
}
