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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("------------------")
        print("HorizontalCollectionViewCell init")
    }

    deinit {
        print("------------------")
        print("HorizontalCollectionViewCell de  de  deinit")
    }
    
}
