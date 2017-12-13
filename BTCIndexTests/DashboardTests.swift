//
//  DashboardTests.swift
//  BTCIndexTests
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import XCTest

@testable import BTCIndex

class DashboardTests: XCTestCase {
    
    var dashboardVC: DashboardViewController!
    var selectedButtonTag: Int = 0
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        dashboardVC = vc
        _ = dashboardVC.view
    }
    
    func testAllTimePressed() {
        selectedButtonTag = 1
        dashboardVC.buttonCollection[0].sendActions(for: .touchUpInside)
        XCTAssertEqual(selectedButtonTag, dashboardVC.selectedButtonTag)
    }
    
    func testDailyPressed() {
        selectedButtonTag = 2
        dashboardVC.buttonCollection[1].sendActions(for: .touchUpInside)
        XCTAssertEqual(selectedButtonTag, dashboardVC.selectedButtonTag)
    }
    
    func testMonthlyPressed() {
        selectedButtonTag = 3
        dashboardVC.buttonCollection[2].sendActions(for: .touchUpInside)
        XCTAssertEqual(selectedButtonTag, dashboardVC.selectedButtonTag)
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
