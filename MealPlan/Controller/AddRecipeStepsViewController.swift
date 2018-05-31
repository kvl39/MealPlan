//
//  AddRecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeStepsViewController: MPIndependentCollectionViewController, AddRecipeStepProtocol {

    var embeddedViewControllers: [UIViewController] = []
    var titleTextViewHints = ""
    var stepInEditing = 0
    var presetInformation = false
    var selectedImage: UIImage = UIImage()
    var selectedDescription: String = ""
    
    @IBOutlet weak var recipeTitleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recipeStepCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedRecipeTitle" {
            if let vc = segue.destination as? InputTextViewController {
                embeddedViewControllers.append(vc)
            }
        } else if segue.identifier == "ShowRecipeStepEditor" {
            if let vc = segue.destination as? AddRecipeStepViewController {
                vc.delegate = self
                vc.row = self.stepInEditing
                if self.presetInformation {
                    vc.presetDescription = selectedDescription
                    vc.presetImage = selectedImage
                    vc.textViewPresetTextColor = UIColor.black
                }
            }
        }
    }
    
    func configureCollectionView() {
        recipeStepCollectionView.delegate = self
        recipeStepCollectionView.dataSource = self
        recipeStepCollectionView.register(UINib(nibName: "RecipeStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeStepCollectionViewCell")
    }

    func configureTextViewHints() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.textViewHint = self.titleTextViewHints
            vc.configureTextFieldEmpty()
        }
    }
    
    func resetFrame() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.resetFrame()
        }
    }
    
    func setRecipeTitleTextViewHeight(newHeight: CGFloat) {
        self.recipeTitleTextViewHeight.constant = newHeight
        self.view.layoutIfNeeded()
    }
    
    func reloadTableViewRow(stepImage: UIImage, stepDescription: String, row: Int) {
        if row == self.itemArray.count {
            self.itemArray.append(.recipeStepCollectionViewType(stepImage, stepDescription))
        } else {
            self.itemArray[row] = .recipeStepCollectionViewType(stepImage, stepDescription)
        }
        
        recipeStepCollectionView.reloadData()
    }
    
    
    @IBAction func addRecipeButtonDidPressed(_ sender: UIButton) {
        self.stepInEditing = itemArray.count
        presetInformation = false
        performSegue(withIdentifier: "ShowRecipeStepEditor", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.stepInEditing = indexPath.row
        presetInformation = true
        guard let cell = recipeStepCollectionView.cellForItem(at: indexPath) as? RecipeStepCollectionViewCell,
            let image = cell.recipeStepImage.image,
            let description = cell.recipeStepDescription.text else {return}
        selectedImage = image
        selectedDescription = description
        performSegue(withIdentifier: "ShowRecipeStepEditor", sender: self)
    }
    

}
