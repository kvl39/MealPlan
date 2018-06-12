//
//  IngredientEditTableViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class IngredientEditTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ingredientTitleView: UIView!
    @IBOutlet weak var ingredientWeightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
