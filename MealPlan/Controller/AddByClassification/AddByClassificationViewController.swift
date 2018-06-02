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


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerForScrollView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultContainerView: UIView!
    @IBOutlet weak var searchButtonLabel: UILabel!

    
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
    var selectedRowImageView = UIImageView()
    weak var delegate: AddByClassificationDelegateProtocol?
    var embeddedViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("child count: \(self.childViewControllers.count)")
        initialConfigueViews()
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func cropTagView() {
//        let cutDirection = UIBezierPath()
//        cutDirection.move(to: CGPoint(x: 0, y: recipeImage.frame.height-10))
//        cutDirection.addLine(to: CGPoint(x: 0, y: 10))
//        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: 10))
//        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: recipeImage.frame.height-10))
//        cutDirection.addQuadCurve(to: CGPoint(x: 0, y: recipeImage.frame.height-10), controlPoint: CGPoint(x: view.frame.width/2, y: controlY))
//        containerForScrollView.path = cutDirection.cgPath
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        originalScrollViewY = containerForScrollView.frame.origin.y
        originalSearchButtonViewY = searchButton.frame.origin.y
        originalIndicatorViewY = activityIndicator.frame.origin.y
        guard let textVC = self.embeddedViewControllers[0] as? InputTextViewController else {return}
        textVC.resetFrame()
        configureTextViewHints()
    }
    
    
    func pushToDetailView(recipeCalendarModel: RecipeCalendarRealmModel, selectedRowImageView: UIImageView) {
        guard let detailViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "MPRecipeDetailViewController") as? MPRecipeDetailViewController else {return}
        detailViewController.recipeData = recipeCalendarModel
        detailViewController.displayImage = selectedRowImageView.image
        self.selectedRowImageView = selectedRowImageView
        self.navigationController?.pushViewController(detailViewController, animated: true)
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
        } else if segue.identifier == "TextViewInAddByClassfication" {
            guard let vc = segue.destination as? InputTextViewController else {return}
            self.embeddedViewControllers.append(vc)
            vc.showSeparationLine = false
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
        let containerForScrollViewY = max(20, -1 * subViewMoveDistance + 120)
        containerForScrollView.frame.origin = CGPoint(x: containerForScrollView.frame.origin.x, y: containerForScrollViewY)
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
    
    
    func configureTextViewHints() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.textViewHint = "Enter something or choose tags"
            vc.configureTextFieldEmpty()
        }
    }

}



extension AddByClassificationViewController: ZoomingViewController {
    
    func zoomingImageView() -> UIImageView? {
        return self.selectedRowImageView
    }
}
