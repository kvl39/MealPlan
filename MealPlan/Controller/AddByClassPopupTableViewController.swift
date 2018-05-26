//
//  AddByClassPopupTableViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddByClassPopupTableViewController: MPTableViewController {

    @IBOutlet weak var popupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        popupTableView.delegate = self
        popupTableView.dataSource = self
        
        
    }

    
}
