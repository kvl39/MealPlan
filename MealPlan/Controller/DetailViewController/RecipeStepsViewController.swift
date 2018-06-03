//
//  RecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/3.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class RecipeStepsViewController: MPIndependentCollectionViewController {

    @IBOutlet weak var recipeStepsCollectionView: UICollectionView!
    var recipeSteps = [RecipeStep]()
    var saveImageManager = SaveImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureData()
    }
    
    func configureData() {
        for recipeStep in recipeSteps {
            if let recipeStepDescription = recipeStep["stepDescription"] as? String,
               let recipeImageName = recipeStep["imageName"] as? String,
                let recipeStepImage = self.saveImageManager.getSavedImage(imageFileName: recipeImageName) {
                self.itemArray.append(.recipeStepCollectionViewType(recipeStepImage, recipeStepDescription))
            }
        }
    }

    func configureCollectionView() {
        recipeStepsCollectionView.delegate = self
        recipeStepsCollectionView.dataSource = self
        recipeStepsCollectionView.register(UINib(nibName: "RecipeStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeStepCollectionViewCell")
    }
    
   
    @IBAction func finishButtonDidPressed(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
