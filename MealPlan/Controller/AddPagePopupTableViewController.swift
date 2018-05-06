//
//  AddPagePopupTableViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/6.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPagePopupTableViewController: MPTableViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        configureTableView()
        
    }

    
    func configureTableView(){
        
        
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        
        var imageArray = [UIImage]()
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "iTunesArtwork"))
        
        self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_like_normal"), "1st row"))
        self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_back"), "2nd row"))

    }
    
    
    
    

}
