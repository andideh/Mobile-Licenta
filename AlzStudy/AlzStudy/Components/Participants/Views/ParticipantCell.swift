//
//  ParticipantCell.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 14/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift

final class ParticipantCell: UITableViewCell, ValueCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with value: String) {
        self.nameLabel.text = value
    }
    
    
}
