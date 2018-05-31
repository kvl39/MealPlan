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
        configureObserver()
    }
    
    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addIngredient(notification:)), name: NSNotification.Name(rawValue: "addIngredient"), object: nil)
    }
    
    @objc func addIngredient(notification: Notification) {
        self.rowArray[0].insert(.recipeIngredientEditType, at: 0)
        //self.rowArray[0].append(.addIngredientType)
        self.addIngredientTableView.reloadData()
    }
    
    func configureTableView() {
        addIngredientTableView.delegate = self
        addIngredientTableView.dataSource = self
        addIngredientTableView.register(UINib(nibName: "IngredientEditTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientEditTableViewCell")
        addIngredientTableView.register(UINib(nibName: "MPIngredientAddButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "MPIngredientAddButtonTableViewCell")
        self.rowArray.append([])
        //self.rowArray[0].append(.recipeIngredientEditType)
        self.rowArray[0].append(.addIngredientType)
    }

    
}
