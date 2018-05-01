//
//  HorizontalCollectionView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class HorizontalCollectionView: MPCollectionViewController {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
        
    }
    
    func configureCollectionView(){
        
        self.horizontalCollectionView.delegate = self
        self.horizontalCollectionView.dataSource = self
        self.horizontalCollectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")
        
        imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_selected"))
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

