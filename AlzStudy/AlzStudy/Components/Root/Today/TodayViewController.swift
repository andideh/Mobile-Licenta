//
//  TodayViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/4/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


class TodayViewController: BaseViewController {
    
    
    static func instantiate() -> UINavigationController {
        return UIStoryboard(name: "Today", bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pieChart = self.getPieChart()
        self.view.addSubview(pieChart)
    }
    
    func getPieChart() -> UIView {
        let item1 = PNPieChartDataItem(dateValue: 20, dateColor:  PNLightGreen, description: "Build")
        let item2 = PNPieChartDataItem(dateValue: 20, dateColor: PNFreshGreen, description: "I/O")
        let item3 = PNPieChartDataItem(dateValue: 45, dateColor: PNDeepGreen, description: "WWDC")
        let frame = CGRect(x: 40, y: 155, width: 240, height: 240)
        let items: [PNPieChartDataItem] = [item1, item2, item3]
        let pieChart = PNPieChart(frame: frame, items: items)
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
        pieChart.center = self.view.center
        return pieChart
    }
}
