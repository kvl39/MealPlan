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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipeManager = RecipeManager(delegate: self)
        
        //recipeManager.getRecipe(keyWord: "?q=fish&app_id=f15e641c&app_key=cf64c20f394531bb6c9669f48bb0932f&to=2")
    }
    
    func manager(_ manager: RecipeManager, didGet products: RecipeModel) {
        
    }
    
    func manager(_ manager: RecipeManager, didFailWith error: MPError) {
        
    }

    
}
