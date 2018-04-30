//
//  ProgressViewController.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/23/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

final class ProgressViewController: BaseNonStoryboardViewController {

    // MARK: - Public properties

    // MARK: - Private properties

    private var chartView: BarsChart!

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        chartView.values = ["Mon":0.8, "Tue":0.4, "Wed":0.65]
    }

    // MARK: - Public methods

    override func configureUI() {
        view.backgroundColor = .white
        chartView = BarsChart.autoLayout()
    }

    override func configureLayout() {
        view.addSubview(chartView)

        let constraints = [
            chartView.centerYAnchor == view.centerYAnchor,

            chartView.leadingAnchor == view.leadingAnchor,
            chartView.trailingAnchor == view.trailingAnchor,
            chartView.heightAnchor == 400.0
        ]

        constraints.activate()
    }

    // MARK: - Private methods


}
