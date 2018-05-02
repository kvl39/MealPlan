//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import Charts

class TestViewController: MPTableViewController {

    
    @IBOutlet weak var testTable: UITableView!
    let calendarInstance: MPCalendarView = MPCalendarView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //detailTableView.register(UINib(nibName: "contentDetailHeaderImageCell", bundle: nil), forCellReuseIdentifier: "contentDetailHeaderImageCell")
        testTable.delegate = self
        testTable.dataSource = self
        
        
        configureTableView()
        
        
    }

    func configureTableView(){
        
        testTable.register(UINib(nibName: "CalendarCollectionView", bundle: nil), forCellReuseIdentifier: "CalendarCollectionView")//only for reuse? but if this line is removed, it crashes!
        testTable.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        self.rowArray.append(.calendarCollectionViewType)
       
       var imageArray = [UIView]()
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       self.rowArray.append(.horizontalCollectionViewType(.imageType, imageArray))
        
        
        var imageArray2 = [UIView]()
        imageArray2.append(generateViewWithPieChart(value: 60))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(.imageType, imageArray2))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectDate(notification:)), name: NSNotification.Name(rawValue: "SelectDate"), object: nil)
        
    }
    
    func generateViewWithImage(image: UIImage)->UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    func generateViewWithPieChart(value: Double)->UIView {
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
    
    @objc func onSelectDate(notification:Notification)
    {
        guard let userInfo = notification.userInfo,
              let date = userInfo["date"] as? String else {return}
        print(date)
    }
    

}
