//
//  MeasurementsDataSource.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 29/11/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

final class MeasurementsDataSource: ValueCellDataSource {

    override func registerClasses(collectionView: UICollectionView) {
        collectionView.register(MeasurementCell.self, forCellWithReuseIdentifier: MeasurementCell.defaultReuseId)
    }

    func loadForm(_ values: [ParameterViewData]) {
        self.set(values: values, cellClass: MeasurementCell.self, inSection: 0)
    }
    
    override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        case (let cell as MeasurementCell, let value as ParameterViewData): cell.configure(with: value)
        default: fatalError("Unrecognized (\(type(of: cell)), \(type(of: value))) combo.")
        }
    }
}
