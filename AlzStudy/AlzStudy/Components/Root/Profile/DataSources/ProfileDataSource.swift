//
//  ProfileDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

final class ProfileDataSource: ValueCellDataSource {
    
    func load(profile: [ParameterViewData]) {
        self.set(values: profile, cellClass: ProfileCell.self, inSection: 0)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case (let cell as ProfileCell, let value as ParameterViewData): cell.configure(with: value)
            
        default: fatalError()
        }
    }
}
