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
    var titleArray: [String] = []
    var itemCount: Int = 0
    var selectedIndexPath: IndexPath!
}

extension MPCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewArray.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? HorizontalCollectionViewCell else { return }
        print("row:\(indexPath.row)")
        let subImageview = viewArray[indexPath.row]
        subImageview.layer.cornerRadius = 5
        subImageview.layer.masksToBounds = true
        subImageview.translatesAutoresizingMaskIntoConstraints = false
        cell.collectionViewCell.addSubview(subImageview)
        NSLayoutConstraint.activate([
            subImageview.leadingAnchor.constraint(equalTo: cell.collectionViewCell.leadingAnchor, constant: 10),
            subImageview.trailingAnchor.constraint(equalTo: cell.collectionViewCell.trailingAnchor, constant: -10),
            subImageview.topAnchor.constraint(equalTo: cell.collectionViewCell.topAnchor, constant: 10),
            subImageview.bottomAnchor.constraint(equalTo: cell.collectionViewCell.bottomAnchor, constant: -10)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as? HorizontalCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewArray.count-1 >= indexPath.row {
            viewArray[indexPath.row].removeFromSuperview()
        }
        
    }
    
}



extension MPCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 180)
    }
}


