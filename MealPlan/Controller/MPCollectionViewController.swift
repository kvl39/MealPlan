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
        
        print("%%%%%Cell will display row \(indexPath.row)%%%%%")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as? HorizontalCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        
//        cell.collectionViewCell.subviews.map{ $0.removeFromSuperview() }
        let subImageview = viewArray[indexPath.row]
        print("---------index Path cell for row \(indexPath.row)--------")
        print(subImageview.superview ?? "No super view")
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
//        cell.collectionViewCell.layoutIfNeeded()
//        if let viewWithTag = cell.viewWithTag(2) {
//            viewWithTag.removeFromSuperview()
//        }
//        let subView = viewArray[indexPath.row]
//        subView.layer.cornerRadius = 5
//        subView.layer.masksToBounds = true
//        subView.tag = 2
//        cell.collectionViewCell.addSubview(subView)
//        subView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subView.leadingAnchor.constraint(equalTo: cell.collectionViewCell.leadingAnchor, constant: 10),
//            subView.trailingAnchor.constraint(equalTo: cell.collectionViewCell.trailingAnchor, constant: -10),
//            subView.topAnchor.constraint(equalTo: cell.collectionViewCell.topAnchor, constant: 10),
//            subView.bottomAnchor.constraint(equalTo: cell.cardLabel.topAnchor, constant: -10)
//            ])
//        cell.cardLabel.text = titleArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("@@@@@@@@end display cell for row \(indexPath.row)@@@@@@@@")
        viewArray[indexPath.row].removeFromSuperview()
    }
    
}



extension MPCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
}


