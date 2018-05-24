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
    var firebaseManager = MPFirebaseManager()
    var recipeIngredients = [[String: Any]]()
    
    
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
        
        //information to display: label, nutrient, ingredient(String)
        self.sectionArray = ["材料","營養成分"]
        configureData()
        configureTableView()

        
        /////////////////fake data
//        recipeDetailTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
//
//        rowArray.append([])
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "pig"), "pig"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
//        rowArray[0].append(.recipeCellType(#imageLiteral(resourceName: "spinach"), "vegatable"))
    }
    
    
    func configureData() {
        if self.recipeData.withSteps {
            self.recipeTitle.text = self.recipeData.recipeRealmModelWithSteps?.label
            if let recipeRealmIngredient = recipeData.recipeRealmModelWithSteps?.ingredients {
                self.recipeIngredients = firebaseManager.recipeIngredientRealmModelToDictionary(recipeIngredients: Array(recipeRealmIngredient))
            }
            
        } else {
            self.recipeTitle.text = self.recipeData.recipeRealmModel?.label
            if let recipeRealmIngredient = recipeData.recipeRealmModel?.ingredients {
                self.recipeIngredients = firebaseManager.recipeIngredientRealmModelToDictionary(recipeIngredients: Array(recipeRealmIngredient))
            }
        }
    }
    
    func configureTableView() {
        recipeDetailTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        recipeDetailTableView.register(UINib(nibName: "RecipeDetailIngredientCell", bundle: nil), forCellReuseIdentifier: "RecipeDetailIngredientCell")
        
        
        rowArray.append([])
        for ingredient in self.recipeIngredients{
            if let ingredientName = ingredient["name"] as? String {
                rowArray[0].append(.recipeIngredientType(ingredientName))
                print(ingredientName)
            }
        }
        rowArray.append([])
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
        rowArray[1].append(.recipeIngredientType("ingredient test2"))
    }
    
    
    
    func updateImage(height: CGFloat) {
        //let controlY = recipeImage.frame.height*1.5 - self.originImageHeight*0.5
        let controlY = recipeImage.frame.height + 10
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: recipeImage.frame.height-10))
        cutDirection.addLine(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: recipeImage.frame.height-10))
        cutDirection.addQuadCurve(to: CGPoint(x: 0, y: recipeImage.frame.height-10), controlPoint: CGPoint(x: view.frame.width/2, y: controlY))
        newHeaderLayer.path = cutDirection.cgPath
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(UITableViewAutomaticDimension)
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        recipeDetailTableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        let titleY = max(self.originTitleY - recipeDetailTableView.contentOffset.y, 60)
        let titleOriginY = max(height-recipeTitle.frame.height/2, 60)
        
        recipeImage.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: UIScreen.main.bounds.size.width-40, height: height)
        //recipeTitle.frame = CGRect(x: recipeTitle.frame.origin.x, y: view.safeAreaInsets.top + height-recipeTitle.frame.height/2, width: recipeTitle.frame.width, height: titleY)
        //recipeTitle.frame = CGRect(x: recipeTitle.frame.origin.x, y: titleOriginY, width: recipeTitle.frame.width, height: titleY)
        updateImage(height: height)
    }
}


