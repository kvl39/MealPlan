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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //detailTableView.register(UINib(nibName: "contentDetailHeaderImageCell", bundle: nil), forCellReuseIdentifier: "contentDetailHeaderImageCell")
        testTable.delegate = self
        testTable.dataSource = self
        testTable.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
        
        configureTableView()
        
    }

    func configureTableView(){
        
        self.rowArray.append(.horizontalCollectionView)
        
    }
    
    
    

}
