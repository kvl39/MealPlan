//
//  CreateRecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/29.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class CreateRecipeStepsViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollStepsView: UIScrollView!
    
    
    
    var currentStep = 1
    var numberOfSteps = 4
    var stepIndicationWidth: CGFloat = 0.0
    var controllersArray: [UIViewController] = []
    var capturedPhoto: UIImage?
    var alertmanager = AlertManager()
    var photoIsTaken = false
    var stepImages = [UIImage]()
    var stepDescriptions = [String]()
    var nutrientsValue: [Float] = [0.0, 0.0]
    var nutrientsName = ["卡路里", "脂肪"]
    var ingredientName = [String]()
    var ingredientWeight = [Float]()
    var recipeTitle: String?
    var selectedDate = "2017 08 08"
    let formatter = DateFormatter()
    var dateManager = DataFormatManager()
    var saveImageManger = SaveImageManager()
    let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollStepsView()
        stepIndicationWidth = 0.25 * (self.view.frame.width - 150)
        
    }

    func configureScrollStepsView() {
        scrollStepsView.delegate = self
        scrollStepsView.contentSize.width = 4 * self.view.frame.width
        scrollStepsView.isPagingEnabled = true
        
        for index in 0..<numberOfSteps {
            let view = UIView(frame: CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.scrollStepsView.addSubview(view)
        }
        
        addCameraViewController()
        addPhotoViewController()
        addStepInformationViewController()
        addIngredientInformationViewController()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addCameraViewController() {
        var cameraViewController = CameraViewController()
        addChildViewController(cameraViewController)
        cameraViewController.view.frame = CGRect(x: 0, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        self.scrollStepsView.addSubview(cameraViewController.view)
        didMove(toParentViewController: cameraViewController)
        self.controllersArray.append(cameraViewController)
    }
    
    func addPhotoViewController() {
        guard let photoViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as? PhotoViewController else {return}
        addChildViewController(photoViewController)
        photoViewController.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        photoViewController.view.layoutIfNeeded()
        self.scrollStepsView.addSubview(photoViewController.view)
        didMove(toParentViewController: photoViewController)
        self.controllersArray.append(photoViewController)
        print("photo view height:\(self.scrollStepsView.frame.height)")
    }
    
    func addStepInformationViewController() {
        guard let addRecipeStepsViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "AddRecipeStepsViewController") as? AddRecipeStepsViewController else {return}
        addChildViewController(addRecipeStepsViewController)
        addRecipeStepsViewController.view.frame = CGRect(x: 2*self.view.frame.width, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        self.scrollStepsView.addSubview(addRecipeStepsViewController.view)
        didMove(toParentViewController: addRecipeStepsViewController)
        self.controllersArray.append(addRecipeStepsViewController)
        addRecipeStepsViewController.titleTextViewHints = "Enter Recipe Title"
        addRecipeStepsViewController.configureTextViewHints()
        addRecipeStepsViewController.resetFrame()
    }
    
    func addIngredientInformationViewController() {
        guard let addRecipeIngredientViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "AddRecipeIngredientViewController") as? AddRecipeIngredientViewController else {return}
        addChildViewController(addRecipeIngredientViewController)
        addRecipeIngredientViewController.view.frame = CGRect(x: 3*self.view.frame.width, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        self.scrollStepsView.addSubview(addRecipeIngredientViewController.view)
        didMove(toParentViewController: addRecipeIngredientViewController)
        self.controllersArray.append(addRecipeIngredientViewController)
    }
    
    
    func finishCheck() {
        var warningMessage = ""
        var warnings = 0
        self.stepDescriptions = []
        self.stepImages = []
        self.ingredientName = []
        self.ingredientWeight = []
        self.nutrientsValue = [0.0, 0.0]
        
        if !photoIsTaken {
            warnings += 1
            warningMessage += "No recipe photo"
        }
        
        if let recipeStepVC = controllersArray[2] as? AddRecipeStepsViewController {
            if recipeStepVC.itemArray.count == 0 {
                //no steps
                warnings += 1
                warningMessage += "no steps"
            } else {
                self.stepDescriptions = recipeStepVC.recipeStepDescription
                self.stepImages = recipeStepVC.recipeStepImage
            }
            
            if let recipeTitleVC = recipeStepVC.embeddedViewControllers[0] as? InputTextViewController {
                if recipeTitleVC.textView.textColor == UIColor.gray {
                    //no title
                    warningMessage += "no title"
                    warnings += 1
                } else {
                    self.recipeTitle = recipeTitleVC.textView.text
                }
            }
        }
        
        if let recipeIngredientVC = controllersArray[3] as? AddRecipeIngredientViewController {
            var hasValidData = false
            for index1 in 0..<recipeIngredientVC.rowControllerArray.count {
                if let ingredientTitleVC = recipeIngredientVC.rowControllerArray[index1][0] as? InputTextViewController,
                    let ingredientWeightVC = recipeIngredientVC.rowControllerArray[index1][1] as? InputTextViewController {
                    
                    if ((ingredientWeightVC.textView.textColor == UIColor.black) &&
                        (ingredientTitleVC.textView.textColor == UIColor.black)) {
                        hasValidData = true
                        self.ingredientName.append(ingredientTitleVC.textView.text)
                     self.ingredientWeight.append(Float(ingredientWeightVC.textView.text)!)
                    }
                
                }
            }
            if hasValidData == false {
                warningMessage += "no ingredient"
                warnings += 1
            }
            
            
        }
        
        if warnings > 0 {
            alertmanager.showAlert(viewController: self, text: "Some thing is missing")
        } else {
            let recipe = saveData()
            if let recipeCalendarModel = recipe {
                realmManager.saveUserCreatedRecipe(createdRecipe: recipeCalendarModel)
            }
            if let image = self.capturedPhoto, let title = self.recipeTitle {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CreatedRecipe"), object: nil, userInfo: ["createdRecipeImage": image, "createdRecipeTitle": title])
            }
            //self.navigationController?.popToRootViewController(animated: true)
        }
 
    }
    
    
    func saveData()-> RecipeCalendarRealmModel? {
        let recipeModel = RecipeCalendarRealmModel()
        guard let addDate = self.dateManager.stringToDate(dateString: selectedDate, to: "yyyy MM dd") else {return nil}
        recipeModel.recipeDay = addDate
        recipeModel.withSteps = true
        
        let recipeRealmModelWithSteps = RecipeRealmModelWithSteps()
        if let recipeTitle = self.recipeTitle {
            recipeRealmModelWithSteps.label = recipeTitle
            if let recipeImage = self.capturedPhoto {
                self.saveImageManger.saveImage(image: recipeImage, imageFileName: "\(recipeTitle)_RecipeImage")
                recipeRealmModelWithSteps.image = "\(recipeTitle)_RecipeImage"
            }
            
            for index in 0...self.stepDescriptions.count - 1 {
                let step = RecipeStep()
                step.stepDescription = stepDescriptions[index]
                step.imageName = "\(recipeTitle)_StepImage_\(index)"
                self.saveImageManger.saveImage(image: self.stepImages[index], imageFileName: "\(recipeTitle)_StepImage_\(index)")
                recipeRealmModelWithSteps.RecipeSteps.append(step)
            }
        }
        
        recipeRealmModelWithSteps.calories = Double(self.nutrientsValue[0])
        
        for index in 0...self.ingredientName.count-1 {
            let ingredient = IngredientRecipeModel()
            ingredient.name = self.ingredientName[index]
            ingredient.weight = Double(self.ingredientWeight[index])
            recipeRealmModelWithSteps.ingredients.append(ingredient)
        }
        
        
        for index in 0...self.nutrientsValue.count-1 {
            let nutrient = Nutrients()
            nutrient.label = self.nutrientsName[index]
            nutrient.quantity = Double(self.nutrientsValue[index])
            recipeRealmModelWithSteps.nutrients.append(nutrient)
        }
        
        recipeModel.recipeRealmModelWithSteps = recipeRealmModelWithSteps
        
        return recipeModel
    }
    
    func updatePhotoView() {
        if let photoVC = self.controllersArray[1] as? PhotoViewController {
            photoVC.takenPhoto = self.capturedPhoto
            print("photo height:\(photoVC.takenPhoto?.size.height)")
            photoVC.updatePhoto()
        }
        self.photoIsTaken = true
    }
    
    func reTakePicture() {
        if let cameraVC = self.controllersArray[0] as? CameraViewController {
            cameraVC.configureViewWillAppear()
        }
        self.scrollStepsView.setContentOffset(CGPoint(x: 0.0, y: self.scrollStepsView.contentOffset.y), animated: true)
        self.photoIsTaken = false
    }
    
    func scrollToLeft() {
        self.scrollStepsView.setContentOffset(CGPoint(x: self.scrollStepsView.contentOffset.x-self.view.frame.width, y: self.scrollStepsView.contentOffset.y), animated: true)
    }
    
    func scrollToRight() {
        self.scrollStepsView.setContentOffset(CGPoint(x: self.scrollStepsView.contentOffset.x+self.view.frame.width, y: self.scrollStepsView.contentOffset.y), animated: true)
    }
    
    func scrollToPage(destinationPage: Int) {
        if (photoIsTaken && (destinationPage == 0)) {
            alertmanager.showAlertForCamera(viewController: self)
            reTakePicture()
        } else if ((photoIsTaken == false)&&(destinationPage>0)) {
            alertmanager.showAlertForPhoto(viewController: self)
        } else {
            self.scrollStepsView.setContentOffset(CGPoint(x: CGFloat(destinationPage)*self.view.frame.width, y: self.scrollStepsView.contentOffset.y), animated: true)
        }
    }

}

extension CreateRecipeStepsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollStepsView {
            print("scroll view offset:\(scrollView.contentOffset)")
        }
        
        let page = Int(scrollView.contentOffset.x / self.view.frame.width)
        let newX = (0.25 - (7.5/self.view.frame.width)) * scrollView.contentOffset.x + 30
        
        for child in childViewControllers {
            if let child = child as? MPScrollNavigationViewController {
                child.updateScrollBarPosition(newX: newX, page: page)
            }
        }
        
    }
    
}
