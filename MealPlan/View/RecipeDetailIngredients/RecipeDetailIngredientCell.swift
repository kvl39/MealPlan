//
//  RecipeDetailIngredientCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/24.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class RecipeDetailIngredientCell: UITableViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        collectionViewCell.layer.cornerRadius = 3.0
//        collectionViewCell.layer.masksToBounds = false
//        collectionViewCell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        collectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        collectionViewCell.layer.shadowOpacity = 0.8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
