//
//  Router.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import UIKit

enum HistoryPeriod: String {
    case daily
    case monthly
    case alltime
}

class Router {
    
    let window: UIWindow?
    var dashBoardVC: DashboardViewController?
    init(window: UIWindow?) {
        self.window = window
        self.setDashboardVC()
        self.startTimer()
    }
    
    func setDashboardVC() {
        if let viewController =  self.window?.rootViewController as? DashboardViewController{
            self.dashBoardVC = viewController
        }
    }
    
    /// Get current day price index
    @objc func getPriceIndices() {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!, isHeaderRequired: true)
        networkManager.get() { (data, error) in
            guard let data = data else {
                print("error =", error?.localizedDescription ?? "")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let priceIndices = try jsonDecoder.decode(PriceIndices.self, from: data)
                self.setPriceIndices(priceIndices: priceIndices)
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    func setPriceIndices(priceIndices: PriceIndices) {
        DispatchQueue.main.async {
            self.dashBoardVC?.priceIndices = priceIndices
        }
    }
    
    /// Get Historical Data
    func getHistoryData(period: HistoryPeriod) {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=\(period.rawValue)&?format=json")!, isHeaderRequired: false)
        networkManager.get() { (data, error) in
            guard let data = data else { return }
            do {
                if let dataSerialised = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]] {
                    switch period {
                    case .daily:
                        let value =  dataSerialised.enumerated().map({ (offset, element) -> DailyHistory? in
                            return self.getDailyHistory(data: element)
                        })
                        if let value = value as? [DailyHistory] {
                            DispatchQueue.main.async { self.dashBoardVC?.dailyHistoryData = value.reversed() }
                        }
                    case .monthly:
                        let value =  dataSerialised.enumerated().map({ (offset, element) -> MonthlyHistory? in
                            return self.getMonthlyHistory(data: element)
                        })
                        if let value = value as? [MonthlyHistory] {
                            DispatchQueue.main.async { self.dashBoardVC?.monthlyHistoryData = value.reversed() }
                        }
                    case .alltime:
                        let value =  dataSerialised.enumerated().map({ (offset, element) -> AllTimeHistory? in
                            return self.getAllTimeHistory(data: element)
                        })
                        if let value = value as? [AllTimeHistory] {
                            DispatchQueue.main.async { self.dashBoardVC?.allTimeHistoryData = value.reversed() }
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    func getDailyHistory(data: [String: Any]) -> DailyHistory? {
        let historyData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        do {
            let history = try JSONDecoder().decode(DailyHistory.self, from: historyData!)
            return history
        } catch {
            print("Error")
        }
        return nil
    }
    
    func getMonthlyHistory(data: [String: Any]) -> MonthlyHistory? {
        let historyData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        do {
            let history = try JSONDecoder().decode(MonthlyHistory.self, from: historyData!)
            return history
        } catch {
            print("Error")
        }
        return nil
    }
    
    func getAllTimeHistory(data: [String: Any]) -> AllTimeHistory? {
        let historyData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        do {
            let history = try JSONDecoder().decode(AllTimeHistory.self, from: historyData!)
            return history
        } catch {
            print("Error")
        }
        return nil
    }
    
    func startTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.getPriceIndices), userInfo: nil, repeats: true)
        timer.fire()
    }
}
