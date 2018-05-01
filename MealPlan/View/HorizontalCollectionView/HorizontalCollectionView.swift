//
//  HorizontalCollectionView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class HorizontalCollectionView: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    var imageArray:[UIImage] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

extension HorizontalCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as! HorizontalCollectionViewCell
        cell.collectionViewImage.image = imageArray[indexPath.row]
        return cell
    }
    
}
