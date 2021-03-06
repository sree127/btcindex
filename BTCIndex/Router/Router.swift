//
//  Router.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

/// Fetch the API for PriceIndices and History Data
/// Takes in UIWindow as parameter from AppDelegate through Dependency Injection


import Foundation
import UIKit

/// Enum to switch between different history period
/// Enum raw value is used to get the data from the history API
enum HistoryPeriod: String {
    case daily
    case monthly
    case alltime
}

class Router {
    
    let window: UIWindow?
    var dashBoardVC: DashboardViewController?
    var timer: Timer?
    init(window: UIWindow?) {
        self.window = window
        self.setDashboardVC()
        self.startTimer()
        self.listenToAppStates()
    }
    
    /// Get the DashboardViewController from UIWindow rootViewController
    func setDashboardVC() {
        if let viewController =  self.window?.rootViewController as? DashboardViewController{
            self.dashBoardVC = viewController
        }
    }
    
    /// Get current day Price Indices
    @objc func getPriceIndices() {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!, isSignatureNeeded: true)
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
    
    /// Dependeny Injection to set the priceIndices in DashboardViewController
    /// Using Main thread becuase the didSet loads the UITableView
    func setPriceIndices(priceIndices: PriceIndices) {
        DispatchQueue.main.async {
            self.dashBoardVC?.priceIndices = priceIndices
        }
    }
    
    /// Get Historical Data based on the HistoryPeriod
    /// On completion, data is converted to corresponding Model depending on the period
    /// Models --> DailyHistory, MonthlyHistory, AllTimeHistory which are all Codable Protocol to deserialise the Data
    func getHistoryData(period: HistoryPeriod) {
        let networkManager = NetworkManager(session: URLSession(configuration: .default), url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=\(period.rawValue)&?format=json")!, isSignatureNeeded: false)
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
    
    /// Get the DailyHistory codable form
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
    
    /// Get the MonthlyHistory codable form
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
    
    /// Get the AllTimeHistory codable form
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
    
    /// Listen to Application states
    func listenToAppStates() {
        let notificationCenter = NotificationCenter.default
        /// Listen when the ApplicationMoves to background
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    /// Timer scheduled to run every 3 seconds to fetch the Price Indices
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.getPriceIndices), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    /// Stop timer triggered when App Moves to background
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Called when the Notification observer send the UIApplicationWillResignActive event
    @objc func appMovedToBackground() {
        stopTimer()
    }
}
