//
//  AddRecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeStepsViewController: UIViewController {

    var embeddedViewControllers: [UIViewController] = []
    var titleTextViewHints = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedRecipeTitle" {
            if let vc = segue.destination as? InputTextViewController {
                embeddedViewControllers.append(vc)
            }
        }
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

}
