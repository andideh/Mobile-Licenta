//
//  DateCell.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


final class DateCell: UICollectionViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with value: String) {
        self.titleLabel.text = value
    }
    
}

