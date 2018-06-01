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
    @IBOutlet weak var containerForScrollView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var searchResultViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfTagView: NSLayoutConstraint!
    @IBOutlet weak var searchButtonLabel: UILabel!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    
    var hintTextArray = [String]()
    var isShowingHint = false
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
        topImageView.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        //backgroundView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background008"))
        print("child count: \(self.childViewControllers.count)")
        initialConfigueViews()
        initialConfigureHintView()
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initialConfigureHintView() {
        hintView.alpha = 0
        hintView.layer.cornerRadius = 10
        hintView.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        originalScrollViewY = containerForScrollView.frame.origin.y
        originalSearchButtonViewY = searchButton.frame.origin.y
        originalIndicatorViewY = activityIndicator.frame.origin.y
    }
    
    
    func updateHeightOfTagView(newHeight: CGFloat){
        UIView.animate(withDuration: 0.2) {
            self.heightOfTagView.constant = newHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func updateHintArray(newHintText: String) {
        self.hintTextArray.append(newHintText)
        if isShowingHint == false {
            showHint()
        }
    }
    
    
    func showHint() {
        if self.hintTextArray.count > 0 {
            hintLabel.text = self.hintTextArray[0]
            self.isShowingHint = true
            UIView.animate(withDuration: 0.5, animations: {
                self.hintView.alpha = 1
            }) { (showViewComplete) in
                self.hintTextArray.remove(at: 0)
                UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
                    self.hintView.alpha = 0
                }, completion: { (hideViewComplete) in
                    self.showHint()
                })
            }
        } else {
            self.isShowingHint = false
        }
    }
    
    func initialConfigueViews() {
        stopActivityIndicator()
        hideSearchTable()
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
        UIView.animate(withDuration: 0.4) {
            self.showSearchTable()
        }
    }
    
    func failToGetSearchResult() {
        stopActivityIndicator()
        hideSearchTable()
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
        searchButtonLabel.alpha = 0
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        searchButtonLabel.alpha = 1
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
    
    func adjustView(subViewMoveDistance: CGFloat) {
        //let newHeight = min(contentInsetY-200, originalScrollViewY)
//        containerForScrollView.frame.origin = CGPoint(x: containerForScrollView.frame.origin.x, y: originalScrollViewY - contentInsetY)
//        searchButton.frame.origin = CGPoint(x: searchButton.frame.origin.x, y: originalSearchButtonViewY - contentInsetY)
//        activityIndicator.frame.origin = CGPoint(x: activityIndicator.frame.origin.x, y: originalIndicatorViewY - contentInsetY)
        //searchResultViewTopConstraint.constant = contentInsetY
        //self.view.layoutIfNeeded()
        //searchButton.alpha = 1 - subViewMoveDistance/30
        containerForScrollView.alpha = 1 - subViewMoveDistance/200
        containerForScrollView.frame.origin = CGPoint(x: containerForScrollView.frame.origin.x, y: -1 * subViewMoveDistance + 120)
        if subViewMoveDistance > 0 {
            searchButton.isUserInteractionEnabled = false
            containerForScrollView.isUserInteractionEnabled = false
        } else {
            searchButton.isUserInteractionEnabled = true
            containerForScrollView.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func ConfirmButtonDidPressed(_ sender: UIButton) {
        for childVC in childViewControllers {
            if let childVC = childVC as? SearchViewController {
                childVC.confirmSelection()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func updateTagView() {
        for childVC in childViewControllers {
            if let childVC = childVC as? MPTagViewController {
                childVC.createTag(onView: childVC.view, with: self.selectedTags)
            }
        }
    }

}
