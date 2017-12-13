//
//  DashboardViewController.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import UIKit
import Charts
import QuartzCore

class DashboardViewController: UIViewController {

    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeInPriceLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var lineCharView: LineChartView!
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var btcImageView: UIImageView!
    
    var selectedButtonTag = 2
    var priceIndices: PriceIndices? {
        didSet {
            self.setPriceIndices()
        }
    }
    
    /// HistoryData
    var monthlyHistoryData: [MonthlyHistory] = [MonthlyHistory]()
    var allTimeHistoryData: [AllTimeHistory] = [AllTimeHistory]()
    var dailyHistoryData: [DailyHistory] = [] {
        didSet {
            drawChartView(period: .daily)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.btcImageView.rotateView()
    }
    
    func drawChartView(period: HistoryPeriod) {
        changeButtonStates()
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
        self.btcImageView.removeAllAnimations()
    }
    
    func setPriceIndices() {
        self.currentPriceLabel.text = "$" +  String(describing: priceIndices?.last ?? 0)
        self.openPriceLabel.text = String(describing: priceIndices?.open.day ?? 0)
        self.highPriceLabel.text = String(describing: priceIndices?.high ?? 0)
        self.lowPriceLabel.text = String(describing: priceIndices?.low ?? 0)
        let changeInPrice = priceIndices?.changes.price.day ?? 0.0
        let changeInPercentage = priceIndices?.changes.percent.day ?? 0.0
        let changePriceString = String(describing: changeInPrice) + " (\(String(describing: changeInPercentage))%)"
        changeInPriceLabel.text = changePriceString
        changeInPriceLabel.textColor = changeInPrice > 0.0 ? ChartColorTemplates.colorFromString("#038152") : ChartColorTemplates.colorFromString("#B20000")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func monthlyPressed(_ sender: Any) {
        selectedButtonTag = 1
        drawChartView(period: .monthly)
    }
    
    @IBAction func dailyPressed(_ sender: Any) {
        selectedButtonTag = 2
        drawChartView(period: .daily)
    }
    
    @IBAction func allTimePressed(_ sender: Any) {
        selectedButtonTag = 3
        drawChartView(period: .alltime)
    }
    
    func changeButtonStates() {
        for button in buttonCollection {
            button.setTitleColor(button.tag == selectedButtonTag ? ChartColorTemplates.colorFromString("#E5276A") : ChartColorTemplates.colorFromString("#625E9A"), for: .normal)
        }
    }
}
