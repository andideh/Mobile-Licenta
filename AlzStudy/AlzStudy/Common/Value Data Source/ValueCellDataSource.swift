//
//  ValueCellDataSource.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/12/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

private typealias ValueCellType = (value: Any, reusableId: String)

class ValueCellDataSource: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    
    private var values: [[ValueCellType]] = []
    
    // MARK : - Public API
    func elementsIn(section: Int) -> Int {
        return values[section].count
    }
    
    func configureCell(tableCell cell: UITableViewCell, withValue value: Any) { }
    
    func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) { }

    func registerClasses(tableView: UITableView) { }
    
    func clearValues() {
        self.values = [[]]
    }
    
    func clearValues(in section: Int) {
        self.values[section] = []
    }
    
    func set<Cell: ValueCell, Value: Any>(values: [Value], cellClass: Cell.Type, inSection section: Int) where Cell.Value == Value {
        
        self.padValuesForSection(section)
        self.values[section] = values.map { ($0, cellClass.defaultReuseId) }
    }
    
    // MARK: - UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (value, cellId) = self.values[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        configureCell(tableCell: cell, withValue: value)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (value, cellId) = self.values[indexPath.section][indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        configureCell(collectionCell: cell, withValue: value)
        
        return cell
    }
    
    // MARK : - Private API
    func padValuesForSection(_ section: Int) {
        guard values.count <= section else { return }
        
        (self.values.count...section).forEach { _ in
            self.values.append([])
        }
    }
    
}
