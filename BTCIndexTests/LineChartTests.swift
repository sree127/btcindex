//
//  LineChartTests.swift
//  BTCIndexTests
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import XCTest
@testable import Charts

class LineChartTests: XCTestCase {
    
    var chart: LineChartView!
    var dataSet: LineChartDataSet!
    
    override func setUp() {
        super.setUp()

        // Sample data
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        
        for (i, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(i), y: value))
        }
        
        dataSet = LineChartDataSet(values: entries, label: "First unit test data")
        dataSet.drawIconsEnabled = false
        dataSet.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        chart = LineChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        chart.backgroundColor = NSUIColor.clear
        chart.leftAxis.axisMinimum = 0.0
        chart.rightAxis.axisMinimum = 0.0
        chart.data = LineChartData(dataSet: dataSet)
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
