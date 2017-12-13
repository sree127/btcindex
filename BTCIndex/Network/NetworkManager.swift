//
//  NetworkManager.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import CryptoSwift

/// Completion Result typealias
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

/// URLSession Protocol for better code isolation and testability towards Mock values
protocol URLSessionProtocol {
    func dataTaskWithURLRequest(urlRequest: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
/// DataTaskProtocol to resume the n/w operation
protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }

/// URLSession Conforming to URLSessionProtocol
extension URLSession: URLSessionProtocol {
    func dataTaskWithURLRequest(urlRequest: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequest, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

/// Network Manager
/// Manages the API connectivity for the app

class NetworkManager {
    
    typealias completion = (_ data: Data?, _ error: Error?) -> ()
    private let session: URLSessionProtocol
    private let url: URL
    private let isSignatureNeeded: Bool
    
    init(session: URLSessionProtocol = URLSession.shared, url: URL, isSignatureNeeded: Bool) {
        self.session = session
        self.url = url
        self.isSignatureNeeded = isSignatureNeeded
    }
    
    /// URL request creation
    /// X-signature header added if additional header is required
    /// No need to add X-signature for normal history API's
    private var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        if isSignatureNeeded {
            request.setValue(Authentication().signatureHeader, forHTTPHeaderField: "X-signature")
        }
        return request
    }

    /// Fires the request - GET
    /// Session here used is URLSessionProtocol which has the dataTaskWithURLRequest method
    func get(callback: @escaping completion) {
        let task = session.dataTaskWithURLRequest(urlRequest: urlRequest) { (data, _, error) in
            switch (data, error) {
            case (_, let error?):
                callback(nil, error)
            case (let data?, _):
                callback(data, nil)
            case (nil, nil):
                callback(nil, nil)
            }
        }
        task.resume()
    }
}
