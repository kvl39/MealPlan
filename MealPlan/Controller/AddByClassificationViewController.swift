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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    
    var selectedTags = [String]()
    var tags: AddPageTag = AddPageTag()
    var selectedRecipesName: [String] = []
    var selectedRecipes: [RecipeInformation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.backgroundColor = UIColor(red: 167/255.0, green: 210/255.0, blue: 203/255.0, alpha: 1.0)
        print("child count: \(self.childViewControllers.count)")
        initialConfigueViews()
    }
    
    func initialConfigueViews() {
        stopActivityIndicator()
        hideSearchTable()
        configureHintView(isShown: true, text: "Choose tags then start searching")
    }
    
    func configureHintView(isShown: Bool, text: String) {
        hintLabel.text = text
        hintView.alpha = isShown ? 1:0
    }
    
    func hideSearchTable() {
        for childVC in childViewControllers {
            if let childVC = childVC as? SearchViewController {
                childVC.view.alpha = 0
            }
        }
    }
    
    func showSearchTable() {
        for childVC in childViewControllers {
            if let childVC = childVC as? SearchViewController {
                childVC.view.alpha = 1
            }
        }
    }
    
    func didGetSearchResult() {
        stopActivityIndicator()
        hideSearchTable()
        configureHintView(isShown: false, text: "")
        UIView.animate(withDuration: 0.4) {
            self.showSearchTable()
        }
    }
    
    func failToGetSearchResult() {
        stopActivityIndicator()
        hideSearchTable()
        configureHintView(isShown: true, text: "No results. Please choose other tag combinations")
    }

    @IBAction func startSearchButtonDidPressed(_ sender: UIButton) {
        //get search tags
        //start search and progress indicator
        
        startActivityIndicator()
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
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToSearchResult" {
            let vc = segue.destination as? SearchViewController
            vc?.selecteRecipeName = self.selectedRecipesName
            vc?.selectedRecipes = self.selectedRecipes
        }
    }
    

}
