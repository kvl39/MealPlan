//
//  RecipeStepCollectionViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class RecipeStepCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var recipeStepImage: UIImageView!
    @IBOutlet weak var recipeStepDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeStepImage.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

}
