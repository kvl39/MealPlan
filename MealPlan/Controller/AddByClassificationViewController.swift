//
//  AddByClassificationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddByClassificationViewController: MPTableViewController {

    @IBOutlet weak var topImageView: UIImageView!
    var selectedTags = [String]()
    var tags: AddPageTag = AddPageTag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.backgroundColor = UIColor(red: 167/255.0, green: 210/255.0, blue: 203/255.0, alpha: 1.0)
        print("child count: \(self.childViewControllers.count)")
    }
    
    

    @IBAction func startSearchButtonDidPressed(_ sender: UIButton) {
        //get search tags
        //start search and progress indicator
        
        for childVC in childViewControllers {
            if let childVC = childVC as? MPHorizontalScrollViewController {
                childVC.getSelectedTags()
            }
        }
        
        for childVC in childViewControllers {
            if let childVC = childVC as? SearchViewController {
                self.tags.tags = self.selectedTags
                childVC.tagArray = tags
                childVC.startSearching()
            }
        }
        
    }
    
    
    

}
