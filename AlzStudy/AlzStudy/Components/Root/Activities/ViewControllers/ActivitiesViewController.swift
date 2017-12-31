//
//  ActivitiesViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

final class ActivitiesViewController: BaseViewController {

    // MARK: - Public properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    
    private let viewModel: ActivitiesViewModelType = ActivitiesViewModel()
    private let dataSource = ActivitiesDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self.dataSource
        self.viewModel.inputs.viewDidLoad()
        
        self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let service: LocalNotificationsService = AppEnvironment.current.serviceProvider.getService()
//        service.requestPermissionIfNeeded(self)
    }
    
    // MARK: - Public methods
    
    static func instantiate() -> UINavigationController {
        return Storyboard.Activities.instantiateInitial() as UINavigationController
    }
    
    override func bindViewModel() {
        self.viewModel.outputs.loadTodayTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.loadTodayTasks($0)
                self?.collectionView.reloadData()
            }
        
        self.viewModel.outputs.loadYesterdayTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.loadYesterdayTasks($0)
                self?.collectionView.reloadData()
        }
        
        self.viewModel.outputs.goToTest
            .observeForControllerAction()
            .observeValues { [weak self] in
                let numbersVC = NumbersViewController.instantiate()
                
                numbersVC.configure(test: $0)
                
                self?.present(numbersVC, animated: true)
            }
        
       
    }
    
    // MARK: - Private methods
    
    
}


extension ActivitiesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.inputs.didSelect(item: indexPath)
    }

}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 84.0
        let width = self.view.bounds.width * 0.9
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
