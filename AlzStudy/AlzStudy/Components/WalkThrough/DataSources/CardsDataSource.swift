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
}
