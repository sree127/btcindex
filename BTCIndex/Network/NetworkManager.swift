//
//  NetworkManager.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import CryptoSwift

class NetworkManager {
    
    typealias completion = (_ data: Data?, _ error: Error?) -> ()
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    
    private var timeStamp: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    private var publicKey: String {
        return "OWE3YzJkMzlhNGIxNDllYzk1NWYwMDE1NzQ2NWM2ZTU"
    }
    
    private var secretKey: String {
        return "MmY2YTU2YTY3NDljNDFiOTkzYzY1ODY0MWQ4MzRiNTQwNjhiNTVmZDYyYTg0ZjljYWRjMWE1NGNkNjljYTViZA  "
    }
    
    private var payload: String {
        return String(timeStamp) + "." + publicKey
    }
    
    private var digest: String {
        let hmac: Array<UInt8> = try! HMAC(key: secretKey, variant: .sha256).authenticate([UInt8](payload.utf8))
        return hmac.toHexString()
    }
    
    private var signatureHeader: String {
        return payload + "." + digest
    }

    func getCurrentPrice(url: URL, callback: @escaping completion) {
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.setValue(signatureHeader, forHTTPHeaderField: "X-signature")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, _, error) in
            switch (data, error) {
            case (_, let error?):
                print("Error **", error.localizedDescription)
                callback(nil, error)
            case (let data?, _):
                callback(data, nil)
            case (nil, nil):
                print("error")
                callback(nil, nil)
            }
        }
        task.resume()
    }
}
