//
//  AddRecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeStepsViewController: MPTableViewController, AddRecipeStepProtocol {

    var embeddedViewControllers: [UIViewController] = []
    var titleTextViewHints = ""
    var stepInEditing = 0
    var presetInformation = false
    var selectedImage: UIImage = UIImage()
    var selectedDescription: String = ""
    
    @IBOutlet weak var recipeTitleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recipeStepTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rowArray.append([])
        configureTableView()
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
                }
            }
        }
    }
    
    func configureTableView() {
        recipeStepTableView.delegate = self
        recipeStepTableView.dataSource = self
        recipeStepTableView.register(UINib(nibName: "RecipeStepTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeStepTableViewCell")
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
        if row == self.rowArray[0].count {
            self.rowArray[0].append(.recipeStepTableViewCellType(stepDescription, stepImage))
        } else {
            self.rowArray[0][row] = .recipeStepTableViewCellType(stepDescription, stepImage)
        }
        
        recipeStepTableView.reloadData()
    }
    
    
    @IBAction func addRecipeButtonDidPressed(_ sender: UIButton) {
        self.stepInEditing = rowArray[0].count
        presetInformation = false
        performSegue(withIdentifier: "ShowRecipeStepEditor", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.stepInEditing = indexPath.row
        presetInformation = true
        guard let cell = recipeStepTableView.cellForRow(at: indexPath) as? RecipeStepTableViewCell,
            let image = cell.recipeStepImage.image,
            let description = cell.recipeStepDescription.text else {return}
        selectedImage = image
        selectedDescription = description
        performSegue(withIdentifier: "ShowRecipeStepEditor", sender: self)
    }
    

}
