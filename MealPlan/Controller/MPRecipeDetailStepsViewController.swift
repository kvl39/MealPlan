//
//  MPRecipeDetailStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/25.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailStepsViewController: MPTableViewController {

    
    @IBOutlet weak var stepsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func configureTableView() {
        stepsTable.delegate = self
        stepsTable.dataSource = self
    }
    

}
