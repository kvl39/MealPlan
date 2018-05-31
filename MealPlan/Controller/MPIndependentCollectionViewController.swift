//
//  MPIndependentCollectionViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit


enum MPCollectionViewCellType {
    case recipeStepCollectionViewType(UIImage, String)
}

extension MPCollectionViewCellType {
    func configureCell()-> MPIndependentCollectionViewCellProtocol {
        switch self {
        case .recipeStepCollectionViewType(let recipeStepImage, let recipeStepDescription):
            return RecipeStepCollectionViewItem(recipeStepImage: recipeStepImage, recipeStepDescription: recipeStepDescription)
        }
    }
}


protocol MPIndependentCollectionViewCellProtocol {
    var reuseIdentifier: String {get}
    var rowSize: CGSize {get}
}

struct RecipeStepCollectionViewItem: MPIndependentCollectionViewCellProtocol {
    var reuseIdentifier: String = "RecipeStepCollectionViewCell"
    var rowSize: CGSize = CGSize(width: 130.0, height: 250.0)
    var recipeStepImage = UIImage()
    var recipeStepDescription = ""
    
    init(recipeStepImage: UIImage, recipeStepDescription: String) {
        self.recipeStepImage = recipeStepImage
        self.recipeStepDescription = recipeStepDescription
    }
}

class MPIndependentCollectionViewController: UIViewController {
    
    var itemArray = [MPCollectionViewCellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MPIndependentCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        switch item {
        case .recipeStepCollectionViewType:
            guard let cell = cell as? RecipeStepCollectionViewCell else {return}
            guard let itemStruct = item.configureCell() as? RecipeStepCollectionViewItem else {return}
            cell.recipeStepImage.image = itemStruct.recipeStepImage
            cell.recipeStepDescription.text = itemStruct.recipeStepDescription
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemArray[indexPath.row]
        switch item {
        case .recipeStepCollectionViewType:
            guard let itemStruct = item.configureCell() as? RecipeStepCollectionViewItem else {return UICollectionViewCell()}
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemStruct.reuseIdentifier, for: indexPath)
            return cell
        }
    }
    
    
}


extension MPIndependentCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var cellWidth = (screenWidth-16)/3
        var cellHeight = cellWidth * 237 / 130
        
//        if screenWidth < 375 {
//            cellWidth = screenWidth
//            cellHeight = cellWidth * 114 / 185
//        }
        
        return CGSize(width: cellWidth, height: cellHeight)
        
        //return CGSize(width: 130, height: 250)
    }
    
}


