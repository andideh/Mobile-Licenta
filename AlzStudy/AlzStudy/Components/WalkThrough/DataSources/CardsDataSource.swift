//
//  CardsDataSource.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class CardsDataSource: ValueCellDataSource {
   
    func load(cards: [CardViewData]) {
        self.set(values: cards, cellClass: CardViewCell.self, inSection: 0)
    }
    
    
    override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        case (let cell as CardViewCell, let value as CardViewData):
            cell.configure(with: value)
            
            
        default:
            fatalError("Unrecognized (\(type(of: cell)), \(type(of: value))) combo.")
        }
    }
}
