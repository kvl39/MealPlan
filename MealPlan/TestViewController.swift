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
    let pieChartManager = MPPieChart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
       self.rowArray.append(.horizontalCollectionViewType(imageArray))
        
        
        var imageArray2 = [UIView]()
        imageArray2.append(pieChartManager.generateViewWithPieChart(value: 40))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(imageArray2))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectDate(notification:)), name: NSNotification.Name(rawValue: "SelectDate"), object: nil)
        
    }
    
    func generateViewWithImage(image: UIImage)->UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    @objc func onSelectDate(notification:Notification)
    {
        guard let userInfo = notification.userInfo,
              let date = userInfo["date"] as? String else {return}
        print(date)
    }
    

}
