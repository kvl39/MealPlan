//
//  MPCollectionViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit


class MPCollectionViewController: UITableViewCell {

    var viewArray: [UIView] = []
    var itemCount: Int = 0

}

extension MPCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as! HorizontalCollectionViewCell
        if let viewWithTag = cell.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
        let subView = viewArray[indexPath.row]
        subView.tag = 2
        cell.collectionViewCell.addSubview(subView)
        return cell
    }
    
}
