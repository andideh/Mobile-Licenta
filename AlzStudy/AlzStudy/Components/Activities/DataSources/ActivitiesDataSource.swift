//
//  ActivitiesDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class ActivitiesDataSource: ValueCellDataSource {
    
    enum Sections: Int {
        case todo
        case todoTasks
        case done
        case doneTasks

        var title: String {
            switch self {
            case .todo: return "To-do"
            case .done: return "Done"
            default: return ""
            }
        }
    }

    override func registerClasses(collectionView: UICollectionView) {
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.defaultReuseId)
        collectionView.register(TitledSectionCell.self, forCellWithReuseIdentifier: TitledSectionCell.defaultReuseId)
        collectionView.register(NoItemsCell.self, forCellWithReuseIdentifier: NoItemsCell.defaultReuseId)
    }
    
    func loadTodo(_ tasks: [Activity]) {
        self.set(values: [Sections.todo.title], cellClass: TitledSectionCell.self, inSection: Sections.todo.rawValue)
        self.set(values: tasks, cellClass: ActivityCell.self, inSection: Sections.todoTasks.rawValue)
    }
    
    func loadDoneTasks(_ tasks: [Activity]) {
        self.set(values: [Sections.done.title], cellClass: TitledSectionCell.self, inSection: Sections.done.rawValue)
        self.set(values: tasks, cellClass: ActivityCell.self, inSection: Sections.doneTasks.rawValue)
    }

    func clearTodoTasks() {
        self.set(values: [Sections.todo.title], cellClass: TitledSectionCell.self, inSection: Sections.todo.rawValue)
        self.set(values: [()], cellClass: NoItemsCell.self, inSection: Sections.todoTasks.rawValue)
    }

    func clearDoneTasks() {
        self.set(values: [Sections.done.title], cellClass: TitledSectionCell.self, inSection: Sections.done.rawValue)
        self.set(values: [()], cellClass: NoItemsCell.self, inSection: Sections.doneTasks.rawValue)
    }

    override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        case (let cell as TitledSectionCell, let value as String): cell.configure(with: value)
        case (let cell as ActivityCell, let value as Activity): cell.configure(with: value)
        case (let cell as NoItemsCell, let value as Void): cell.configure(with: value)
        default: fatalError()
        }
    }
}
