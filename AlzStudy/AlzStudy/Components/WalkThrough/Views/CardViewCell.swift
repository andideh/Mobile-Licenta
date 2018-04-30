//
//  CardViewCell.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class CardViewCell: UICollectionViewCell, ValueCell {
    
    typealias Value = CardViewData
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinStackView: UIStackView!
    
    
    private var viewModel: CardCellViewModelType = CardCellViewModel()
    
    // MARK: - public methods
    
    func configure(with value: CardViewData) {
        viewModel.inputs.configureWith(viewData: value)
    }
    
    func animateJoinButton() {
        guard self.joinStackView.alpha == 0.0 else { return }
        
        self.joinStackView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.joinStackView.alpha = 1.0
            self.joinStackView.transform = .identity
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel.inputs.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        self.viewModel.outputs.titleText
            .observeForUI()
            .observeValues { [weak self] in
                self?.title.text = $0
            }
        
        self.viewModel.outputs.descriptionText
            .observeForUI()
            .observeValues { [weak self] in
                self?.descriptionLabel.text = $0
            }
        
        self.viewModel.outputs.backgroundColor
            .observeForUI()
            .observeValues { [weak self] in
                self?.backgroundColor = $0
            }
        
        self.viewModel.outputs.cardImage
            .observeForUI()
            .observeValues {
                self.imageView.image = $0
            }
        
        self.viewModel.outputs.joinButtonAlpha
            .observeForUI()
            .observeValues {
                self.joinStackView.alpha = $0
            }
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        let responder: JoinButtonResponder? = findResponder()
        
        responder?.joinButtonTapped()
    }
    
    @IBAction func registerAsDoctorButtonTapped(_ sender: Any) {
        let responder: JoinButtonResponder? = findResponder()
        
        responder?.joinAsDoctor()
    }
}

