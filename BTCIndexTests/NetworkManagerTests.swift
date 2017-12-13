//
//  NetworkManagerTests.swift
//  BTCIndexTests
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import XCTest

@testable import BTCIndex

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    
    func dataTaskWithURLRequest(urlRequest: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = urlRequest.url
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(session: session, url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!, isSignatureNeeded: false)
    }
    
    func testRequestsTheURL() {
        let url = URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")!
        
        networkManager.get { (_, _) in
            
        }
        XCTAssert(session.lastURL == url)
    }
    
    func testStartsTheRequest() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        networkManager.get { (_, _) in
            
        }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testPublicAndPrivateKey() {
        let publicKey = "OWE3YzJkMzlhNGIxNDllYzk1NWYwMDE1NzQ2NWM2ZTU"
        XCTAssertEqual(publicKey, Constants.Keys.publicKey)
        
        let privateKey = "MmY2YTU2YTY3NDljNDFiOTkzYzY1ODY0MWQ4MzRiNTQwNjhiNTVmZDYyYTg0ZjljYWRjMWE1NGNkNjljYTViZA"
        XCTAssertEqual(privateKey, Constants.Keys.secretkey)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

