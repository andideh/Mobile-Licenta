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
    
    // MARK: - Public
    
    static func instantiate() -> WalkThroughViewController {
        return Storyboard.WalkThrough.instantiate() as WalkThroughViewController
    }
    
    // MARK: - Private properties
    
    let dataSource = CardsDataSource()
    let viewModel: WalkThroughViewModelType = WalkThroughViewModel()
    
    // MARK: - VC methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        self.viewModel.inputs.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool { return true } 
    
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.outputs.loadCards
            .observeForUI()
            .observeValues { [weak self] cards in
                self?.dataSource.load(cards: cards)
            }
        
    }
    
    // MARK: - Public methods
    
    
    
    // MARK: - Private methods
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.bounces = false
        
        pageControl.numberOfPages = dataSource.elementsCount
        view.bringSubview(toFront: pageControl)
    }
    
}

extension WalkThroughViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        
        if indexPath.item == dataSource.elementsCount - 1 {
            (cell as! CardViewCell).animateJoinButton()
        }
    }

}

extension WalkThroughViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }

}

