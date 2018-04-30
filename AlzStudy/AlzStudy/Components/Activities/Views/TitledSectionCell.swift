//
//  DateCell.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


final class TitledSectionCell: UICollectionViewCell, ValueCell {
    
    typealias Value = String
    
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with value: String) {
        self.titleLabel.text = value
    }

    func configureUI() {
        titleLabel = UILabel() ~ {
            $0.textColor = .black
            $0.font = Font.futuraMedium(of: .large)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(titleLabel)
        titleLabel.snap(to: self, inset: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0))
    }
}

