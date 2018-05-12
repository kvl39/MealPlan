//
//  MPPieChart.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/2.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import Charts

class MPPieChart {

    func generateViewWithPieChart(value: Double) -> UIView {
        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        let nuitritionEntry = PieChartDataEntry(value: value)
        nuitritionEntry.label = ""
        let restEntry = PieChartDataEntry(value: 100 - value)
        var entries: [PieChartDataEntry] = [nuitritionEntry, restEntry]
        let dataSet = PieChartDataSet(values: entries, label: nil)
        dataSet.selectionShift = 0
        dataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: dataSet)
        let colors = [UIColor.blue, UIColor.white]
        dataSet.colors = colors
        pieChartView.data = chartData
        pieChartView.animate(xAxisDuration: 1)
        pieChartView.legend.enabled = false
        pieChartView.chartDescription?.enabled = false
        pieChartView.holeRadiusPercent = 0.3
        pieChartView.minOffset = 0
        //pieChartView.drawSliceTextEnabled = false
        return pieChartView
    }

}
