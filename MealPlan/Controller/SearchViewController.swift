//
//  SearchViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/7.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class SearchViewController: MPTableViewController, RecipeManagerProtocol {

    var tagArray: AddPageTag!
    var observation: NSKeyValueObservation!
    var recipeManager = RecipeManager()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureObserver()
        configureTableView()
    }
    
    func configureObserver() {
        
        observation = tagArray.observe(\.tags, options: [.new, .old]) { (tagArray, change) in
            print(tagArray.tags)
            var searchKeyword = "?q="
            if tagArray.tags.count > 0 {
                for index in 0...tagArray.tags.count-1 {
                    if index == 0 {
                        searchKeyword = searchKeyword + tagArray.tags[0]
                    } else {
                        searchKeyword = searchKeyword + "%26" + tagArray.tags[index]
                    }
                }
                searchKeyword = searchKeyword + "&app_id=f15e641c&app_key=cf64c20f394531bb6c9669f48bb0932f&to=5"
                self.recipeManager.getRecipe(keyWord: searchKeyword)
            } else {
                self.rowArray = []
                self.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        
        
    }
    
    
    func manager(_ manager: RecipeManager, didGet products: RecipeModel) {
        self.rowArray = []
        for index in 0...products.hits.count-1 {
            self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_back"), products.hits[index].recipe.label))
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func manager(_ manager: RecipeManager, didFailWith error: MPError) {
        
    }

}
