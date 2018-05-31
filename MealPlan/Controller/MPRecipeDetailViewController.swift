//
//  MPRecipeDetailViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/13.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailViewController: MPTableViewController {

    
    @IBOutlet weak var recipeImage: GradientImageViewUpSideDown!
    
    
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var showStepButton: UIButton!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    var displayImage: UIImage!
    var newHeaderLayer: CAShapeLayer!
    let originImageHeight: CGFloat = 300.0
    var originTitleY: CGFloat = 300.0
    var originTableViewY: CGFloat = 300.0
    var recipeData: RecipeCalendarRealmModel!
    var firebaseManager = MPFirebaseManager()
    var recipeIngredients = [[String: Any]]()
    var recipeNutrients = [[String: Any]]()
    var recipeURLString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.image = displayImage
        recipeImage.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = false
        recipeDetailTableView.contentInset = UIEdgeInsets(top: 340, left: 0, bottom: 0, right: 0)
        recipeDetailTableView.delegate = self
        recipeDetailTableView.dataSource = self
        originTitleY = self.recipeTitle.frame.origin.y
        
        backButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
//        newHeaderLayer = CAShapeLayer()
//        newHeaderLayer.fillColor = UIColor.black.cgColor
//        recipeImage.layer.mask = newHeaderLayer
//        updateImage(height: 0.0)
        
        //information to display: label, nutrient, ingredient(String)
        self.sectionArray = ["Ingredient","Nutrient"]
        configureData()
        configureTableView()
        
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.originTableViewY = self.recipeDetailTableView.frame.origin.y
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
            if let recipeRealmNutrient = recipeData.recipeRealmModel?.nutrients {
                self.recipeNutrients = firebaseManager.recipeNuitrientRealmModelToDictionary(recipeNuitrients: Array(recipeRealmNutrient))
            }
        }
    }
    
    func configureTableView() {
        //configureTableViewBackground()
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
        for nutrient in self.recipeNutrients {
            if let nutrientLabel = nutrient["label"] as? String,
                let nutrientQuantity = nutrient["quantity"] as? Double {
                let quantityTwoDecimal = String(format: "%.2f", nutrientQuantity)
                switch (nutrientLabel) {
                case "Energy":
                    rowArray[1].append(.recipeIngredientType("Energy: \(quantityTwoDecimal) kcal"))
                case "Saturated":
                    rowArray[1].append(.recipeIngredientType("Saturated Fat: \(quantityTwoDecimal) g"))
                case "Fat":
                    rowArray[1].append(.recipeIngredientType("Fat: \(quantityTwoDecimal) g"))
                default: return
                }
            }
        }
    }
    
    func configureTableViewBackground(){
        recipeDetailTableView.backgroundColor = UIColor.clear
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.recipeDetailTableView.bounds.size.width, height: self.recipeDetailTableView.bounds.size.height))
        //backgroundView.backgroundColor = UIColor(red: 167/255.0, green: 210/255.0, blue: 203/255.0, alpha: 1)
        //backgroundView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background002"))
        backgroundView.backgroundColor = UIColor.clear
        self.recipeDetailTableView.backgroundView = backgroundView
    }
    
    
    
    func updateImage(height: CGFloat) {
        //let controlY = recipeImage.frame.height*1.5 - self.originImageHeight*0.5
        let controlY = recipeImage.frame.height + 10
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: recipeImage.frame.height-10))
        cutDirection.addLine(to: CGPoint(x: 0, y: 10))
        cutDirection.addLine(to: CGPoint(x: recipeImage.frame.width, y: 10))
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
    
    
    @IBAction func pushToStepPage(_ sender: UIButton) {
        if self.recipeData.withSteps {
            
        } else {
            if let url = self.recipeData.recipeRealmModel?.url {
                self.recipeURLString = url
            }
            performSegue(withIdentifier: "PushToWebView", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToWebView" {
            let vc = segue.destination as? MPRecipeDetailWebViewController
            vc?.urlString = self.recipeURLString
        }
    }
    
    
    @IBAction func backButtonDidPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
        //recipeDetailTableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        let titleY = max(self.originTitleY - recipeDetailTableView.contentOffset.y, 60)
        let titleOriginY = max(height-recipeTitle.frame.height/2, 60)
        //recipeDetailTableView.layoutIfNeeded()
        
        let distance = 340 - y
        let imageHeight = max(300 - distance, 50)
        //imageViewHeight.constant = imageHeight
        
        //recipeImage.gradientLayer.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.main.bounds.size.width, height: imageHeight)
        recipeImage.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.main.bounds.size.width, height: imageHeight)
        //recipeImage.layoutIfNeeded()
        
        //recipeTitle.frame = CGRect(x: recipeTitle.frame.origin.x, y: view.safeAreaInsets.top + height-recipeTitle.frame.height/2, width: recipeTitle.frame.width, height: titleY)
        //recipeTitle.frame = CGRect(x: recipeTitle.frame.origin.x, y: titleOriginY, width: recipeTitle.frame.width, height: titleY)
        //updateImage(height: height)
    }
    
    
    
}


