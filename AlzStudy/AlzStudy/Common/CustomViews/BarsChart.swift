//
//  BarsChart.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/23/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

//private enum LayoutValues {
//    static let label
//}

final class BarsChart: UIView {

    // MARK: - Public properties

    var values: [String:Double] = [:]  {
        didSet {
            configureUI()
        }
    }

    // MARK: - Private properties

    private var bars: [CAShapeLayer] = []

    // MARK: - Lifecycle

    // MARK: - Public methods

    // MARK: - Private methods

    private func configureUI() {
        let height = bounds.height
        let width = bounds.width

        let yPos = height - 20.0
        var xPos: CGFloat = 8.0

        let lblWidth = labelWidth(for: width)
        for (key, value) in values {
            let label = UILabel()
            label.frame = CGRect(x: xPos, y: yPos, width: lblWidth, height: 20.0)
            label.text = key

            addSubview(label)

            let bar = CAShapeLayer()
            let barHeight = height * CGFloat(value)

            let frame = CGRect(x: 0, y: 0, width: 10.0, height: barHeight)
            let path = UIBezierPath(roundedRect: frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 2.5))

            bar.frame = frame
            bar.path = path.cgPath
            bar.fillColor = AppStyle.Colors.green.cgColor
            bar.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            bar.position = CGPoint(x: label.frame.midX, y: yPos)
            bars.append(bar)

            xPos += lblWidth + 8.0
        }

        layer.sublayers = bars
    }

    private func labelWidth(for width: CGFloat) -> CGFloat {
        return width - 7 * 35.0 - 9 * 8.0
    }
}
