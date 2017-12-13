//
//  DashboardViewController.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeInPriceLabel: UILabel!
    
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    
    @IBOutlet weak var lineCharView: LineChartView!

    var priceIndices: PriceIndices? {
        didSet {
            self.setPriceIndices()
        }
    }
    
    /// HistoryData
    var monthlyHistoryData: [MonthlyHistory] = [] {
        didSet {
            drawChartView(period: .monthly)
        }
    }
    var dailyHistoryData: [DailyHistory] = [DailyHistory]()
    var allTimeHistoryData: [AllTimeHistory] = [AllTimeHistory]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func drawChartView(period: HistoryPeriod) {
        var chartValues: [Double] = [Double]()
        switch period {
        case .daily:
            chartValues = dailyHistoryData.flatMap({ $0.average })
        case .monthly:
            chartValues = monthlyHistoryData.flatMap({ $0.average })
        case .alltime:
            chartValues = allTimeHistoryData.flatMap({ $0.average })
        }
        
        let chartView = ChartView(chartView: lineCharView, chartValues: chartValues)
        chartView.drawLineChart()
        
        print("ALL chartValues ****", chartValues)
    }
    
    func setPriceIndices() {
        self.currentPriceLabel.text = String(describing: priceIndices?.last ?? 0)
        self.openPriceLabel.text = String(describing: priceIndices?.open.day ?? 0)
        self.highPriceLabel.text = String(describing: priceIndices?.high ?? 0)
        self.lowPriceLabel.text = String(describing: priceIndices?.low ?? 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func monthlyPressed(_ sender: Any) {
        drawChartView(period: .monthly)
    }
    
    @IBAction func dailyPressed(_ sender: Any) {
        drawChartView(period: .daily)
    }
    
    @IBAction func allTimePressed(_ sender: Any) {
        drawChartView(period: .alltime)
    }
    
}
