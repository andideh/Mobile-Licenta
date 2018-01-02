//
//  ProfileCell.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 01/01/2018.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit
import ReactiveSwift

final class ProfileCell: UITableViewCell, ValueCell {
    
    private let viewModel: ProfileCellViewModelType = ProfileCellViewModel()
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func configure(with value: ParameterViewData) {
        self.viewModel.inputs.configure(with: value)
    }
    
    func bindViewModel() {
        self.viewModel.outputs.image
            .observeForUI()
            .observeValues { [weak self] in
                self?.imageView?.image = $0
            }
        
        self.viewModel.outputs.title
            .observeForUI()
            .observeValues { [weak self] in
                self?.titleLabel.text = $0
            }
        
        self.viewModel.outputs.valueLabel
            .observeForUI()
            .observeValues { [weak self] in
                self?.valueLabel.text = $0 
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bindViewModel()
    }
}
