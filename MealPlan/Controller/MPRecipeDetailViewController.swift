//
//  MPRecipeDetailViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/13.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    var displayImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.image = displayImage
        self.navigationController?.navigationBar.isHidden = false
    }


}

extension MPRecipeDetailViewController: ZoomingViewController {
    func zoomingImageView() -> UIImageView? {
        return recipeImage
    }
}
