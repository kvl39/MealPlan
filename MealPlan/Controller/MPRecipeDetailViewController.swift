//
//  MPRecipeDetailViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/13.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailViewController: MPTableViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    var displayImage: UIImage!
    var newHeaderLayer: CAShapeLayer!
    let originImageHeight: CGFloat = 300.0
    var originTitleY: CGFloat = 300.0
    var recipeData: RecipeCalendarRealmModel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.image = displayImage
        recipeImage.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = false
        recipeDetailTableView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
        recipeDetailTableView.delegate = self
        recipeDetailTableView.dataSource = self
        originTitleY = self.recipeTitle.frame.origin.y
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        recipeImage.layer.mask = newHeaderLayer
        updateImage(height: 0.0)
        
        
        /////////////////fake data
        recipeDetailTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")

        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "pig"), "pig"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
    }
    
    
    
    func updateImage(height: CGFloat) {
        let controlY = recipeImage.frame.height*1.5 - self.originImageHeight*0.5
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: recipeImage.frame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: recipeImage.frame.height))
        cutDirection.addQuadCurve(to: CGPoint(x: 0, y: recipeImage.frame.height), controlPoint: CGPoint(x: view.frame.width/2, y: max(30,controlY)))
        newHeaderLayer.path = cutDirection.cgPath
    }
    
    
}



extension MPRecipeDetailViewController: ZoomingViewController {
    func zoomingImageView() -> UIImageView? {
        return recipeImage
    }
}


extension MPRecipeDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (recipeDetailTableView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        let titleY = max(self.originTitleY - recipeDetailTableView.contentOffset.y, 60)
        
        recipeImage.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.main.bounds.size.width, height: height)
        recipeTitle.frame = CGRect(x: recipeTitle.frame.origin.x, y: view.safeAreaInsets.top + height-recipeTitle.frame.height/2, width: recipeTitle.frame.width, height: titleY)
        updateImage(height: height)
    }
}


