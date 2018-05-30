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
        
//        recipeStepTableView.beginUpdates()
//        //recipeStepTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
//        recipeStepTableView.endUpdates()
        recipeStepTableView.reloadData()
    }
    
    
    @IBAction func addRecipeButtonDidPressed(_ sender: UIButton) {
        self.stepInEditing = rowArray[0].count
        performSegue(withIdentifier: "ShowRecipeStepEditor", sender: self)
    }
    

}
