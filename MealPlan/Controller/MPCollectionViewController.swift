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

}

extension MPCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as? HorizontalCollectionViewCell else {return UICollectionViewCell()}
        if let viewWithTag = cell.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
        let subView = viewArray[indexPath.row]
        subView.layer.cornerRadius = 5
        subView.layer.masksToBounds = true
        subView.tag = 2
        cell.collectionViewCell.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: cell.collectionViewCell.leadingAnchor, constant: 10),
            subView.trailingAnchor.constraint(equalTo: cell.collectionViewCell.trailingAnchor, constant: -10),
            subView.topAnchor.constraint(equalTo: cell.collectionViewCell.topAnchor, constant: 10),
            subView.bottomAnchor.constraint(equalTo: cell.cardLabel.topAnchor, constant: -10)
            ])
        cell.cardLabel.text = titleArray[indexPath.row]
        return cell
    }

}



extension MPCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 150, height: 160)
    }
}
