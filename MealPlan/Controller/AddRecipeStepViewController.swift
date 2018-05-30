//
//  AddRecipeStepViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeStepViewController: UIViewController {

    var embeddedViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetFrame()
        configureTextViewHints()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedRecipeStepDescription" {
            if let vc = segue.destination as? InputTextViewController {
                embeddedViewControllers.append(vc)
                vc.showSeparationLine = false
            }
        }
    }
    
    func configureTextViewHints() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.textViewHint = "Add recipe step description"
            vc.configureTextFieldEmpty()
        }
    }
    
    func resetFrame() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.resetFrame()
        }
    }
    

}
