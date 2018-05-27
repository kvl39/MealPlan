//
//  AddByClassificationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol AddByClassificationDelegateProtocol: class {
    func reloadData(addedRecipeImageView: [UIImageView], addedRecipeTitle: [String])
}

class AddByClassificationViewController: MPTableViewController {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var containerForScrollView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    var selectedTags = [String]()
    var tags: AddPageTag = AddPageTag()
    var selectedRecipesName: [String] = []
    var selectedRecipeImage: [UIImageView] = []
    var selectedRecipes: [RecipeCalendarRealmModel] = []
    var originalScrollViewY: CGFloat = 0.0
    var originalContainerDifference: CGFloat = 0.0
    var originalSearchButtonViewY: CGFloat = 0.0
    var originalIndicatorViewY: CGFloat = 0.0
    var recipeDate = ""
    weak var delegate: AddByClassificationDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.backgroundColor = UIColor(red: 167/255.0, green: 210/255.0, blue: 203/255.0, alpha: 1.0)
        print("child count: \(self.childViewControllers.count)")
        initialConfigueViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        originalScrollViewY = containerForScrollView.frame.origin.y
        originalSearchButtonViewY = searchButton.frame.origin.y
        originalIndicatorViewY = activityIndicator.frame.origin.y
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
            vc?.selectedDate = self.recipeDate
            vc?.delegate = self.delegate
            vc?.selectedRecipeImage = self.selectedRecipeImage
        }
    }
    
    func adjustView(contentInsetY: CGFloat) {
        //let newHeight = min(contentInsetY-200, originalScrollViewY)
        containerForScrollView.frame.origin = CGPoint(x: containerForScrollView.frame.origin.x, y: originalScrollViewY - contentInsetY)
        searchButton.frame.origin = CGPoint(x: searchButton.frame.origin.x, y: originalSearchButtonViewY - contentInsetY)
        activityIndicator.frame.origin = CGPoint(x: activityIndicator.frame.origin.x, y: originalIndicatorViewY - contentInsetY)
    }
    
    
    @IBAction func ConfirmButtonDidPressed(_ sender: UIButton) {
        for childVC in childViewControllers {
            if let childVC = childVC as? SearchViewController {
                childVC.confirmSelection()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    

}
