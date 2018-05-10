//
//  RecipeSearchResultCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/8.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeSearchResultCell: UITableViewCell {

    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var selectRecipe: UIButton!
    
    var recipeSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImage(imageURL: String?) {
        guard let imageURL = imageURL else {return}
        //recipeImage.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "dish"))
        recipeImage.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (image, error, cacheType, url) in
            guard let error = error else {return}
            print(error)
        }
    }

    
    
}
