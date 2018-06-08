//
//  HorizontalCollectionViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var collectionViewCell: UIView!
    @IBOutlet weak var RecipeNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionViewCell.backgroundColor = UIColor.white
        //contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
//        collectionViewCell.layer.cornerRadius = 3.0
//        collectionViewCell.layer.masksToBounds = false
//        collectionViewCell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        collectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        collectionViewCell.layer.shadowOpacity = 0.8

    }

}
