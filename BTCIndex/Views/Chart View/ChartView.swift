//
//  ChartView.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

/// Chartview
/// Takes LineChartView from Dashboard as DI (Dependency Injection) and also the [Double] values which are
/// used to plot the LineChart graph

import Foundation
import UIKit
import Charts

class ChartView: ChartViewDelegate {
    
    let chartView: LineChartView
    let chartValues: [Double]
    
    init(chartView: LineChartView, chartValues: [Double]) {
        self.chartView = chartView
        self.chartValues = chartValues
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
        chartView.noDataFont = UIFont(name: "Quicksand-Medium", size: 15)!
        chartView.noDataTextColor = UIColor.white.withAlphaComponent(0.5)
        
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

        /// Add Marker
        let marker = BalloonMarker(color: ChartColorTemplates.colorFromString("#3f5378"),
                                   font: UIFont(name: "Quicksand-Medium", size: 14)!,
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.chartView?.layer.cornerRadius = 10
        marker.chartView?.layer.masksToBounds = true
        marker.minimumSize = CGSize(width: 70, height: 20)
        chartView.marker = marker
      
        /// Add LineChart Dataset
        let values = chartValues.enumerated().map { (index, data) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: data)
        }
        let dataSet = LineChartDataSet(values: values, label: nil)
        dataSet.lineWidth = 1
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 0
        dataSet.drawIconsEnabled = false
        dataSet.setColor(UIColor.white.withAlphaComponent(0.35))
        dataSet.setCircleColor(.clear)
        dataSet.drawVerticalHighlightIndicatorEnabled = true
        dataSet.highlightColor = ChartColorTemplates.colorFromString("#4DACDD").withAlphaComponent(0.5)
        
        /// Setting the gradient colours
        let gradientColors = [ChartColorTemplates.colorFromString("#102957").cgColor,
                              ChartColorTemplates.colorFromString("#E5276A").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        
        /// Setting the data to chartview
        chartView.data = data
    }
}
