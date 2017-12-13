//
//  DashboardViewController.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getPriceIndex()
    }
    
    func getPriceIndex() {
        NetworkManager(session: URLSession(configuration: .default)).getCurrentPrice(url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!) { (data, error) in
            guard let data = data else {
                print("error =", error?.localizedDescription ?? "")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(PriceIndices.self, from: data)
                print(responseModel)
            } catch let jsonError {
                print(jsonError)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
