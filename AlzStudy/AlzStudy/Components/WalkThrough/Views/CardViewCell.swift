//
//  CardViewCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class CardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    fileprivate var viewData: CardViewData?
    
    // MARK: - public methods
    
    func configure(with viewData: CardViewData) {
        imageView.image = viewData.image
        title.text = viewData.title
        descriptionLabel.text = viewData.description
        backgroundColor = viewData.color
        
        self.viewData = viewData
    }
    
    func animateJoinButton() {
        guard joinButton.alpha == 0.0 else { return }
        
        joinButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.joinButton.alpha = 1.0
            self.joinButton.transform = .identity
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        joinButton.alpha = 0.0
    }
    
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        viewData?.buttonAction?()
    }
}

extension CardViewCell: Reusable { }

