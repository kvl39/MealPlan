//
//  AddRecipeIngredientViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeIngredientViewController: MPTableViewController {

    @IBOutlet weak var addIngredientTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configureTableView() {
        addIngredientTableView.delegate = self
        addIngredientTableView.dataSource = self
        addIngredientTableView.register(UINib(nibName: "IngredientEditTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientEditTableViewCell")
        self.rowArray.append([])
        self.rowArray[0].append(.recipeIngredientEditType)
    }

    
}
