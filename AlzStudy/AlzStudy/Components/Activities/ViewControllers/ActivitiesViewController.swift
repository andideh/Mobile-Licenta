//
//  ActivitiesViewController.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 23/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

private enum LayoutValues {
    static let headerHeight: CGFloat = 130.0
    static let spacing: CGFloat = 12.0
    static let cellHeight: CGFloat = 110.0
    static let sectionHeight: CGFloat = 35.0
    static let padding: CGFloat = 10.0
    static let insets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 12.0, bottom: 0.0, right: 12.0)
}

final class ActivitiesViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    // MARK: - Private properties

    private var headerView: GradientHeaderView!
    private let viewModel: ActivitiesViewModelType = ActivitiesViewModel()
    private let dataSource = ActivitiesDataSource()
    private var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.inputs.viewDidLoad()

        headerView.titleText = Strings.Activities.hello("Steve")
        headerView.detailText = Strings.Activities.disclaimer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let service: LocalNotificationsService = LocalNotificationsService()
        service.requestPermissionIfNeeded(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func bindViewModel() {
        self.viewModel.outputs.loadTodoTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.loadTodo($0)
                self?.collectionView.reloadData()
            }

        self.viewModel.outputs.loadDoneTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.loadDoneTasks($0)
                self?.collectionView.reloadData()
        }

        self.viewModel.outputs.clearTodoTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.clearTodoTasks()
                self?.collectionView.reloadData()
        }

        self.viewModel.outputs.clearDoneTasks
            .observeForUI()
            .observeValues { [weak self] in
                self?.dataSource.clearDoneTasks()
                self?.collectionView.reloadData()
        }

        self.viewModel.outputs.goToNumbersActivity
            .observeForControllerAction()
            .observeValues { [weak self] in
                let numbersVC = NumbersViewController.instantiate()
                numbersVC.configure(task: $0)
                self?.present(numbersVC, animated: true)
            }

        self.viewModel.outputs.goToColorActivity
            .observeForControllerAction()
            .observeValues { [weak self] in
                let colorsActivity = ColorsActivityViewController()
                colorsActivity.configure(with: $0)
                self?.present(colorsActivity, animated: true)
        }

        self.viewModel.outputs.goToGlucoseActivity
            .observeForControllerAction()
            .observeValues { [weak self] in
                let glucoseVC = GlucoseViewController.instantiate()
                glucoseVC.configure(task: $0)
                self?.present(glucoseVC, animated: true)
            }
    }

    override func style() {
        view.backgroundColor = .white
    }

    override func configureUI() {
        headerView = GradientHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.defaultReuseId)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
        collectionView.delegate = self
        collectionView.dataSource = dataSource

        dataSource.registerClasses(collectionView: collectionView)
    }

    override func configureLayout() {
        view.addSubview(headerView)
        view.addSubview(collectionView)

        let constraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20.0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: LayoutValues.headerHeight),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: LayoutValues.spacing),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Private methods
    
    
}


extension ActivitiesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == ActivitiesDataSource.Sections.todoTasks.rawValue else { return }
        self.viewModel.inputs.didSelect(item: indexPath)
    }

}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = ActivitiesDataSource.Sections(rawValue: indexPath.section)!
        var width = view.bounds.width - LayoutValues.insets.left * 2
        var height = LayoutValues.sectionHeight

        switch section {
        case .doneTasks, .todoTasks:
            if let _ = dataSource[section.rawValue] as? [(Activity, String)] {
                width = self.view.bounds.width/2 - LayoutValues.padding*2
                height = LayoutValues.cellHeight
            }
        default: break
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutValues.padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutValues.padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return LayoutValues.insets
    }
}
