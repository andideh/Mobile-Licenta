//
//  TabBarController.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/8/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

enum Tab {
    case activities
    case chart
    case profile

    var image: UIImage {
        switch self {
        case .activities: return Assets.Icons.activities
        case .chart: return Assets.Icons.chart
        case .profile: return Assets.Icons.person.withRenderingMode(.alwaysTemplate)
        }
    }
}

class RootViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    var viewControllers: [UIViewController] = []

    // MARK: - Private properties

    private var tabBar: TabBar!
    private var containerView: UIView!
    private var tabs: [Tab] = [.activities, .chart, .profile]
    private let viewModel: RootViewModelType = RootViewModel()

    private var visibleViewController: UIViewController?

    // MARK: - Lifecycle

    override init() {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bind()
        self.viewModel.inputs.viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? .default
    }

    override func configureUI() {
        tabBar = TabBar(with: self)
        tabBar.translatesAutoresizingMaskIntoConstraints = false

        containerView = UIView() ~ {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override func configureLayout() {
        view.addSubview(containerView)
        view.addSubview(tabBar)

        let constraints: [NSLayoutConstraint] = [
            tabBar.bottomAnchor == view.safeBottomAnchor,
            tabBar.leadingAnchor == view.safeLeadingAnchor,
            tabBar.trailingAnchor == view.safeTrailingAnchor,
            tabBar.widthAnchor == view.widthAnchor,

            containerView.topAnchor == view.safeTopAnchor,
            containerView.leadingAnchor == view.safeLeadingAnchor,
            containerView.trailingAnchor == view.safeTrailingAnchor,
            containerView.bottomAnchor == tabBar.topAnchor
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func style() {
        view.backgroundColor = .white
    }

    func bind() {
        self.viewModel.outputs.viewControllers
            .observeForUI()
            .observeValues { [weak self] in
                self?.viewControllers = $0
                self?.goToViewController(at: 0)
        }
    }

    // MARK: - Private methods

    private func goToViewController(at index: Int) {
        let nextVC = viewControllers[index]
        guard nextVC != visibleViewController else { return }
        
        prepareToShow(vc: nextVC)
        visibleViewController?.willMove(toParentViewController: nil)

        UIView.animate(withDuration: 0.33, animations: {
            self.visibleViewController?.view.alpha = 0.0
            nextVC.view.alpha = 1.0
        }) { _ in
            self.visibleViewController?.view.removeFromSuperview()
            self.addChildViewController(nextVC)
            nextVC.didMove(toParentViewController: self)
            self.visibleViewController = nextVC
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func prepareToShow(vc: UIViewController) {
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.alpha = 0.0
        containerView.addSubview(vc.view)
    }
}

extension RootViewController: TabBarDelegate {

    var numberOfTabs: Int { return tabs.count }

    func imageForTab(at index: Int) -> UIImage {
        return tabs[index].image
    }

    func didTapItem(at index: Int) {
        goToViewController(at: index)
    }
}
