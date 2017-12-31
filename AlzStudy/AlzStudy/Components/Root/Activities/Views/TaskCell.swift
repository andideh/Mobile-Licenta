//
//  TaskCell.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

struct TaskCellViewData {
    let type: TaskType
    let isDone: Bool
}

final class TaskCell: UICollectionViewCell, ValueCell {
    
    typealias Value = TaskCellViewData
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var viewModel: TaskCellViewModelType = TaskCellViewModel()
    
    func configure(with value: TaskCellViewData) {
        self.viewModel.inputs.configure(with: value)
    }
    
    private func bind() {
        self.viewModel.outputs.titleText
            .observeForUI()
            .observeValues { [weak self] in
                self?.titleLabel.text = $0
            }
        
        self.viewModel.outputs.statusImage
            .observeForUI()
            .observeValues { [weak self] in
                self?.imageView.image = $0
            }
        
        self.viewModel.outputs.textColor
            .observeForUI()
            .observeValues { [weak self] in
                self?.titleLabel.textColor = $0
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .white
        self.bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyShadow()
    }
    
    
    
}
