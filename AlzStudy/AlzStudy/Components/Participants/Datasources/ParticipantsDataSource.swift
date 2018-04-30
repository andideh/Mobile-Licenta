//
//  ParticipantsDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 14/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit


final class ParticipantsDataSource: ValueCellDataSource {
    
    private enum Sections: Int {
        case participants
    }
    
    func load(participants: [String]) {
        self.set(values: participants, cellClass: ParticipantCell.self, inSection: Sections.participants.rawValue)
    }
    
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
            
        case (let cell as ParticipantCell, let value as String): cell.configure(with: value)
            
        default: fatalError()
        }
    }
    
}
