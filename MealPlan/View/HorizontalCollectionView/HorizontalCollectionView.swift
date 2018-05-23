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
    
    

    func configureCollectionView() {
        self.horizontalCollectionView.delegate = self
        self.horizontalCollectionView.dataSource = self
        self.horizontalCollectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")
        self.itemCount = self.viewArray.count
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        //guard let imageView = self.viewArray[indexPath.row].viewWithTag(2) as? UIImageView else {return}
        guard let imageView = self.viewArray[indexPath.row] as? UIImageView else {return}
        NotificationCenter.default.post(name: Notification.Name("collectionViewItemDidSelect"), object: nil, userInfo: ["imageView": imageView, "row": indexPath.row])
    }
}




