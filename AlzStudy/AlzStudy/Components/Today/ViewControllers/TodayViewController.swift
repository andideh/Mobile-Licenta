//
//  TodayViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/4/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


class TodayViewController: BaseViewController {
    
    private let viewModel: TodayViewModelType = TodayViewModel()
    
    static func instantiate() -> UINavigationController {
        return UIStoryboard(name: "Today", bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    weak var pieChart: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.chart.center = self.view.center
//    }
    
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.chartData
            .observeForUI()
            .observeValues { [weak self] in
                guard let `self` = self else { return }
                
                self.pieChart?.removeFromSuperview()
                
                let chart = self.createPieChart()
                let todoItem = PNPieChartDataItem(dateValue: CGFloat($0.todo), dateColor:  PNLightGreen, description: "To-do")
                let doneItem = PNPieChartDataItem(dateValue: CGFloat($0.done), dateColor:  PNDeepGreen, description: "Done")
                let items = [todoItem, doneItem]
                chart.items = items
                
                self.view.addSubview(chart)
                self.pieChart = chart
                self.pieChart?.center = self.view.center
                
                chart.strokeChart()
            }
    }
    
    
    private func createPieChart() -> PNPieChart {
        let width = UIScreen.main.bounds.width * 0.8
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: width))
        let pieChart = PNPieChart(frame: rect, items: [])
        
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
        
        return pieChart
    }
    
    
  
}



//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let pieChart = self.getPieChart()
//    self.view.addSubview(pieChart)
//}
//
//func getPieChart() -> UIView {
//    let item1 = PNPieChartDataItem(dateValue: 20, dateColor:  PNLightGreen, description: "Build")
//    let item2 = PNPieChartDataItem(dateValue: 20, dateColor: PNFreshGreen, description: "I/O")
//    let item3 = PNPieChartDataItem(dateValue: 45, dateColor: PNDeepGreen, description: "WWDC")
//    let frame = CGRect(x: 40, y: 155, width: 240, height: 240)
//    let items: [PNPieChartDataItem] = [item1, item2, item3]
//    let pieChart = PNPieChart(frame: frame, items: items)
//    pieChart.descriptionTextColor = UIColor.white
//    pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
//    pieChart.center = self.view.center
//    return pieChart
//}

