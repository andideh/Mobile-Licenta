//
//  WalkThroughViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class WalkThroughViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Public
    
    static func instantiate() -> WalkThroughViewController {
        return Storyboard.WalkThrough.instantiate() as WalkThroughViewController
    }
    
    // MARK: - Private properties
    
    private let dataSource = CardsDataSource()
    private let viewModel: WalkThroughViewModelType = WalkThroughViewModel()
    
    // MARK: - VC methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.viewModel.inputs.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool { return true } 
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadCards
            .observeForUI()
            .observeValues { [weak self] cards in
                self?.dataSource.load(cards: cards)
                self?.collectionView.reloadData()
                self?.pageControl.numberOfPages = cards.count
            }
        
        
        self.viewModel.outputs.goToSetup
            .observeForControllerAction()
            .observeValues { [weak self] in
                let registrationVC = RegistrationViewController.instantiate(with: .participant)
                self?.present(registrationVC, animated: true)
            }
        
        self.viewModel.outputs.goToLastCard
            .observeForUI()
            .observeValues { [weak self] in
                guard let `self` = self else { return }
                
                let lastIndex = IndexPath(item: self.dataSource.elementsIn(section: 0) - 1 , section: 0)
                self.collectionView.scrollToItem(at: lastIndex, at: .right, animated: true)
            }
        
        self.viewModel.outputs.goToDoctorSignup
            .observeForControllerAction()
            .observeValues { [weak self] in
                guard let `self` = self else { return }
                
                let registration = RegistrationViewController.instantiate(with: .doctor)
                self.present(registration, animated: true)
            }
    }
    
    
    // MARK: - Private methods
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.dataSource
        self.collectionView.bounces = false
        
        self.view.bringSubview(toFront: self.pageControl)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.viewModel.inputs.skipButtonTapped()
    }
}

extension WalkThroughViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
        
        if indexPath.item == self.dataSource.elementsIn(section: 0) - 1 {
            (cell as! CardViewCell).animateJoinButton()
            self.skipButton.isHidden = true
        } else {
            if self.skipButton.isHidden {
                self.skipButton.isHidden = false
            }
        }
    }
    
}

extension WalkThroughViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }

}

extension WalkThroughViewController: JoinButtonResponder {
    
    func joinButtonTapped() {
        self.viewModel.inputs.joinTapped()
    }
    
    func joinAsDoctor() {
        self.viewModel.inputs.joinAsDoctor()
    }
}

