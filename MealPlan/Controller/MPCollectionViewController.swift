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
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: cell.collectionViewCell.leadingAnchor, constant: 10),
            subView.trailingAnchor.constraint(equalTo: cell.collectionViewCell.trailingAnchor, constant: -10),
            subView.topAnchor.constraint(equalTo: cell.collectionViewCell.topAnchor, constant: 10),
            subView.bottomAnchor.constraint(equalTo: cell.collectionViewCell.bottomAnchor, constant: -40),
            ])
        return cell
    }
    
}


extension MPCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}
