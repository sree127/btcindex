//
//  ChartView.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartView: ChartViewDelegate {
    
    let chartView: LineChartView
    let historyData: [History]

    init(chartView: LineChartView, historyData: [History]) {
        self.chartView = chartView
        self.historyData = historyData
    }
    
    func drawLineChart() {
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 2.5)
        chartView.drawGridBackgroundEnabled = false
        chartView.minOffset = 0
        
        let leftAxis = chartView.leftAxis
        leftAxis.enabled = false
        leftAxis.gridColor = UIColor.clear
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisLineColor = .clear
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        rightAxis.gridColor = UIColor.clear
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisLineColor = .clear

        let values = historyData.enumerated().map { (index, data) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: data.average)
        }
        let dataSet = LineChartDataSet(values: values, label: nil)
        dataSet.lineWidth = 1
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 0
        dataSet.drawIconsEnabled = false
        dataSet.setColor(UIColor.white.withAlphaComponent(0.35))
        dataSet.setCircleColor(.clear)
        
        let gradientColors = [ChartColorTemplates.colorFromString("#0B2551").cgColor,
                              ChartColorTemplates.colorFromString("#E5276A").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}
