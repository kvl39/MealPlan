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
    var longPressGesture: UILongPressGestureRecognizer!
    var indexOfCellToSwitch: Int = 0
    var cellToSwitch: MPCollectionViewCellType?
    var indexOfCellBeSwitched: Int = 0
    var cellBeSwitched: MPCollectionViewCellType?
    var selectedCell: RecipeStepCollectionViewCell?
    var recipeStepDescription: [String] = []
    var recipeStepImage: [UIImage] = []
    
    @IBOutlet weak var recipeTitleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recipeStepCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        recipeStepCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = recipeStepCollectionView.indexPathForItem(at: gesture.location(in: recipeStepCollectionView)) else {
                break
            }
            selectedCell = recipeStepCollectionView.cellForItem(at: selectedIndexPath) as? RecipeStepCollectionViewCell
            selectedCell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            selectedCell?.alpha = 0.8
            recipeStepCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed: recipeStepCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            recipeStepCollectionView.endInteractiveMovement()
        default:
            recipeStepCollectionView.cancelInteractiveMovement()
        }
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
        recipeStepCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
            self.recipeStepImage.append(stepImage)
            self.recipeStepDescription.append(stepDescription)
        } else {
            self.itemArray[row] = .recipeStepCollectionViewType(stepImage, stepDescription)
            self.recipeStepImage[row] = stepImage
            self.recipeStepDescription[row] = stepDescription
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
