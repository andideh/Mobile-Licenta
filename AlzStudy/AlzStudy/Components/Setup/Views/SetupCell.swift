//
//  SetupCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class SetupCell: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    
    // MARK: - Public methods
    
    func configure(viewData: ParameterViewData) {
        titleLabel.text = viewData.type.title
        checkmarkImage.image = viewData.isFilled ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "empty_checkmark")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkmarkImage.image = #imageLiteral(resourceName: "empty_checkmark")
    }
}


extension SetupCell: Reusable { }
