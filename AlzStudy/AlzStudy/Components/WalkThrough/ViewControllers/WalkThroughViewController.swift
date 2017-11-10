//
//  WalkThroughViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class WalkThroughViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Public
    
    static func instantiate() -> WalkThroughViewController {
        return Storyboard.WalkThrough.instantiate() as WalkThroughViewController
    }
    
    // MARK: - Private properties
    let dataSource = CardsDataSource()
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        configureCollectionView()
    }
    
    override var prefersStatusBarHidden: Bool { return true } 
    
    
    // MARK: - Private methods
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.bounces = false
        
        pageControl.numberOfPages = dataSource.cards.count
        view.bringSubview(toFront: pageControl)
    }
    
    
}

extension WalkThroughViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        
        if indexPath.item == dataSource.cards.count - 1 {
            (cell as! CardViewCell).animateJoinButton()
        }
    }

}

extension WalkThroughViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }

}

extension WalkThroughViewController: CardsDataSourceProtocol {
    
    func joinButtonTapped() {
        let registration = ContainerViewController.instantiate()
        
        registration.modalTransitionStyle = .crossDissolve
        
        self.present(registration, animated: true, completion: nil)
    }
}

extension WalkThroughViewController: Reusable { }
