//
//  RecipeStepTableViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class RecipeStepTableViewCell: UITableViewCell {

    
    @IBOutlet weak var recipeStepImage: UIImageView!
    @IBOutlet weak var recipeStepDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
