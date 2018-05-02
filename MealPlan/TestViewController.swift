//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

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
       
       var imageArray = [UIImage]()
       imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
       imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
       imageArray.append(#imageLiteral(resourceName: "btn_back"))
       imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
       imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
       imageArray.append(#imageLiteral(resourceName: "btn_back"))
       self.rowArray.append(.horizontalCollectionViewType(.imageType, imageArray))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectDate(notification:)), name: NSNotification.Name(rawValue: "SelectDate"), object: nil)
        
    }
    
    @objc func onSelectDate(notification:Notification)
    {
        guard let userInfo = notification.userInfo,
              let date = userInfo["date"] as? String else {return}
        print(date)
    }
    

}
