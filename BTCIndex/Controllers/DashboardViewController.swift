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
    
    /// Selector to identify the button press
    var selectedButtonTag = 2
    
    /// Price Indices Model --> Gets populated initially from the Router Class
    var priceIndices: PriceIndices? {
        didSet {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.setPriceIndices()
            }, completion: nil)
        }
    }
    
    /// Histoical Data from the API --> Gets populated throug DI from the Router Class
    var monthlyHistoryData: [MonthlyHistory] = [MonthlyHistory]()
    var allTimeHistoryData: [AllTimeHistory] = [AllTimeHistory]()
    var dailyHistoryData: [DailyHistory] = [] {
        didSet {
            drawChartView(period: .daily)
        }
    }

    /// Did Load VC
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Cute little animation to rorate the image 3D --> Please check Helper class for implementation
        self.btcImageView.rotateView()
    }
    
    /// Method which pass the [Dobule] values to chartview
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
        
        /// Pass lineCharView along with the [Double] values
        let chartView = ChartView(chartView: lineCharView, chartValues: chartValues)
        chartView.drawLineChart()
        self.btcImageView.removeAllAnimations()
    }
    
    /// UI Method to assign all the labels with PriceIndices values
    func setPriceIndices() {
        currentPriceLabel.text = "$" + String(describing: priceIndices?.last ?? 0)
        openPriceLabel.text = "$" + String(describing: priceIndices?.open.day ?? 0)
        highPriceLabel.text = "$" + String(describing: priceIndices?.high ?? 0)
        lowPriceLabel.text = "$" + String(describing: priceIndices?.low ?? 0)
        let changeInPrice = priceIndices?.changes.price.day ?? 0.0
        let changeInPercentage = priceIndices?.changes.percent.day ?? 0.0
        let changePriceString = "$" + String(describing: changeInPrice) + " (\(String(describing: changeInPercentage))%)"
        changeInPriceLabel.text = changePriceString
        changeInPriceLabel.textColor = changeInPrice > 0.0 ? ChartColorTemplates.colorFromString("#038152") : ChartColorTemplates.colorFromString("#B20000")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Button Action Methods
    //MARK:- Button Actions
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
    
    /// Change Button states depending on Button Press
    func changeButtonStates() {
        for button in buttonCollection {
            button.setTitleColor(button.tag == selectedButtonTag ? ChartColorTemplates.colorFromString("#E5276A") : ChartColorTemplates.colorFromString("#625E9A"), for: .normal)
        }
    }
}
