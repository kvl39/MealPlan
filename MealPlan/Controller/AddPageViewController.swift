//
//  AddPageViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/3.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol AddPageDelegateProtocol: class {
    func reloadData(addedRecipeImageView: [UIImageView], addedRecipeTitle: [String])
}



class AddPageViewController: UIViewController, SearchViewControllerProtocol, AnimationControllerProtocol {

    @IBOutlet var popupView: AddPagePopupView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var dateIndicator: UILabel!

    var effect: UIVisualEffect!
    var isPopup: Bool = false
    var tags: AddPageTag = AddPageTag()
    var animationManager = AddPageAnimationController()
    var addPageHistoryController = AddPageHistoryController()
    var addedRecipe: [RecipeInformation] = []
    var addedRecipeImageView: [UIImageView] = []
    var addedRecipeTitle: [String] = []
    var realmManager = RealmManager()
    var addPagePopupTableViewController = UINavigationController()
    var observation: NSKeyValueObservation!
    var recipeDate = ""
    var dateManager = DataFormatManager()
    weak var delegate: AddPageDelegateProtocol?
    var historyImageArray: [UIImageView] = []
    var historyTitleArray: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureObserver()
        animationManager.delegate = self
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.alpha = 0
        self.navigationController?.navigationBar.isHidden = true
        self.dateIndicator.text = dateManager.extractDayFromDate(dateString: self.recipeDate)
    }

    

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(tagSelected(notification:)), name: NSNotification.Name(rawValue: "SelectTag"), object: nil)
    }
    
    

    @objc func tagSelected(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let tag = userInfo["tagEnglish"] as? String else {return}
        self.animateOut()
        self.tags.tags.append(tag)
        print("selected tag:\(tag)")
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddPageToTagView") {
            guard let vc = segue.destination as? MPTagViewController else {return}
            vc.tagArray = self.tags
        } else if (segue.identifier == "AddPageToSearchView") {
            guard let vc = segue.destination as? SearchViewController else {return}
            //vc.delegate = self
            vc.tagArray = self.tags
        } else if (segue.identifier == "AddPageToHistoryView") {
            guard let vc = segue.destination as? AddPageHistoryController else {return}
            self.addPageHistoryController = vc
            vc.imageArray = self.historyImageArray
            vc.titleArray = self.historyTitleArray
        } else if (segue.identifier == "AddPageToPopView") {
            guard let vc = segue.destination as? UINavigationController else {return}
            self.addPagePopupTableViewController = vc
        }
    }

    
    
    func animateIn(senderTag: Int) {
        self.view.addSubview(popupView)
        popupView.setupView()
        popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupView.alpha = 0
        visualEffectView.alpha = 0

        UIView.animate(withDuration: 0.2) {
            self.visualEffectView.effect = self.effect
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
            self.visualEffectView.alpha = 1
        }
        isPopup = true
    }

    
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            if let popupTableViewController = self.addPagePopupTableViewController.viewControllers.first as? AddPagePopupTableViewController {
                popupTableViewController.animateOutTableCells()
            }
            self.visualEffectView.effect = nil
            self.visualEffectView.alpha = 0
        }) { (_: Bool) in
            self.popupView.removeFromSuperview()
        }
        isPopup = false
    }

    
    
    @IBAction func selectByAction(_ sender: UIButton) {
        if isPopup {
            animateOut()
        } else {
            animateIn(senderTag: 0)
        }
    }

    
    
    @IBAction func confirmSelection(_ sender: Any) {
        self.delegate?.reloadData(addedRecipeImageView: addedRecipeImageView, addedRecipeTitle: addedRecipeTitle)
        realmManager.saveAddedRecipe(addedRecipe: self.addedRecipe, recipeDate: self.recipeDate)
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func selectRecipeAnimation(cell: RecipeSearchResultCell, cellRect: CGRect, selectedRecipe: RecipeInformation) {
        self.addedRecipe.append(selectedRecipe)
        let imageView = UIImageView(image: cell.recipeImage.image)
        self.addedRecipeImageView.append(imageView)
        guard let recipeTitle = cell.recipeTitle.text else {return}
        self.addedRecipeTitle.append(recipeTitle)
        animationManager.selectRecipeAnimation(cell: cell, view: self.view, cellRect: cellRect)
    }

    
    
    func deSelectRecipe(cell: RecipeSearchResultCell, deSelectedRecipe: RecipeInformation) {
        if let index = self.addedRecipe.index(where: {$0.label == deSelectedRecipe.label}) {
            self.addedRecipe.remove(at: index)
        }
    }

    
    
    func selectAnimationDidFinish(animationImage: UIImage, title: String) {
        addPageHistoryController.selectAnimationDidFinish(animationImage: animationImage, animationString: title)
    }

}
