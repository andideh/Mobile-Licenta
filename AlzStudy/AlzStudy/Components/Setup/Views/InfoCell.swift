//
//  InfoCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class InfoCell: UITableViewCell, ValueCell {
    
    typealias Value = ParameterViewData
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    private var viewModel: InfoCellViewModelType = InfoCellViewModel()
    
    // MARK: - Public methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bindViewModel()
    }
    
    
    func configure(with value: ParameterViewData) {
        self.viewModel.inputs.configure(with: value)
    }
    
   
    // MARK: - Private methods
    
    private func bindViewModel() {
        self.viewModel.outputs.titleText
            .observeForUI()
            .observeValues { self.titleLabel.text = $0 }
        
        self.viewModel.outputs.checkmarkImage
            .observeForUI()
            .observeValues { self.checkmarkImage.image = $0 }
    }
}


   
