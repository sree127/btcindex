//
//  NetworkManager.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import CryptoSwift

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithURLRequest(urlRequest: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: URLSessionProtocol {
    func dataTaskWithURLRequest(urlRequest: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequest, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

class NetworkManager {
    
    typealias completion = (_ data: Data?, _ error: Error?) -> ()
    private let session: URLSessionProtocol
    private let url: URL
    private let isHeaderRequired: Bool
    
    init(session: URLSessionProtocol = URLSession.shared, url: URL, isHeaderRequired: Bool) {
        self.session = session
        self.url = url
        self.isHeaderRequired = isHeaderRequired
    }
    
    private var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        if isHeaderRequired {
            request.setValue(Authentication().signatureHeader, forHTTPHeaderField: "X-signature")
        }
        return request
    }

    func get(callback: @escaping completion) {
        let task = session.dataTaskWithURLRequest(urlRequest: urlRequest) { (data, _, error) in
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
