//
//  AboutYouDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

final class AboutYouDataSource: ValueCellDataSource {
    

    func loadForm(_ values: [ParameterViewData]) {
        self.set(values: values, cellClass: InfoCell.self, inSection: 0)
    }
    
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case (let cell as InfoCell, let value as ParameterViewData):
            cell.configure(with: value)
            
        default:
            fatalError("Unrecognized (\(type(of: cell)), \(type(of: value))) combo.")

        }
    }
}
