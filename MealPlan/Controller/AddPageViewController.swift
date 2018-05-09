//
//  AddPageViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/3.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPageViewController: UIViewController, SearchViewControllerProtocol, AnimationControllerProtocol {
    
    @IBOutlet var popupView: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    var isPopup: Bool = false
    var tags: AddPageTag = AddPageTag()
    var animationManager = AddPageAnimationController()
    var addPageHistoryController = AddPageHistoryController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        animationManager.delegate = self
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.alpha = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddPageToTagView") {
            let vc = segue.destination as! MPTagViewController
            vc.tagArray = self.tags
        } else if (segue.identifier == "AddPageToSearchView") {
            let vc = segue.destination as! SearchViewController
            vc.delegate = self
            vc.tagArray = self.tags
        } else if (segue.identifier == "AddPageToHistoryView") {
            let vc = segue.destination as! AddPageHistoryController
            self.addPageHistoryController = vc
        }
    }
    
    func animateIn(senderTag: Int) {
        
        //add container view
        self.view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            ])
        
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
            self.popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popupView.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.alpha = 0
        }) { (success:Bool) in
            self.popupView.removeFromSuperview()
        }
        
        isPopup = false
    }

    @IBAction func selectByAction(_ sender: UIButton) {
        if isPopup {
            self.tags.tags.append("chicken")
            animateOut()
        } else {
            animateIn(senderTag: 0)
        }
    }
    
    func selectRecipeAnimation(cell: RecipeSearchResultCell, cellRect: CGRect, selectedRecipe: RecipeInformation) {
        print("select label:\(selectedRecipe.label)")
        animationManager.selectRecipeAnimation(cell: cell, view: self.view, cellRect: cellRect)
    }
    
    func deSelectRecipe(cell: RecipeSearchResultCell, deSelectedRecipe: RecipeInformation) {
        print("deselect lable:\(deSelectedRecipe.label)")
    }
    
    func selectAnimationDidFinish(animationImage: UIImage) {
        addPageHistoryController.selectAnimationDidFinish(animationImage: animationImage)
    }
    
}
