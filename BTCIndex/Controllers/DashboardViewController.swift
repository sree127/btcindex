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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPriceIndex()
        getHistoryData()
    }
    
    func getPriceIndex() {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!, isHeaderRequired: true)
        networkManager.get() { [weak weakSelf = self] (data, error) in
            guard let data = data else {
                print("error =", error?.localizedDescription ?? "")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let priceIndices = try jsonDecoder.decode(PriceIndices.self, from: data)
                DispatchQueue.main.async {
                    weakSelf?.setPriceIndices(priceIndices: priceIndices)
                }
            //    print(priceIndices)
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    func getHistoryData() {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=daily&?format=json")!, isHeaderRequired: false)
        networkManager.get() { (data, error) in
            guard let data = data else {
                print("error =", error?.localizedDescription ?? "")
                return
            }
            do {
                if let dataSerialised = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]] {
                    let value =  dataSerialised.enumerated().map({ (offset, element) -> History? in
                        return self.getHistoryType(data: element)
                    })
                    print("data ***", value)
                    if let value = value as? [History] {
                        let chartView = ChartView(chartView: self.lineCharView, historyData: value)
                        DispatchQueue.main.async {
                            chartView.drawLineChart()
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    func getHistoryType(data: [String: Any]) -> History? {
        let historyData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        do {
            let history = try JSONDecoder().decode(History.self, from: historyData!)
            return history
        } catch {
            print("Error")
        }
        return nil
    }
    
    
    func setPriceIndices(priceIndices: PriceIndices) {
        self.currentPriceLabel.text = String(describing: priceIndices.last)
        self.openPriceLabel.text = String(describing: priceIndices.open.day)
        self.highPriceLabel.text = String(describing: priceIndices.high)
        self.lowPriceLabel.text = String(describing: priceIndices.low)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
