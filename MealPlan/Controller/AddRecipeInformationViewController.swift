//
//  AddRecipeInformationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/20.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

//problem: check recipe title cell when this cell appears in the screen


import UIKit
import IQKeyboardManagerSwift

class AddRecipeInformationViewController: MPTableViewController {

    @IBOutlet weak var addRecipeInformationTable: UITableView!
    var cellHeight: [CGFloat] = []
    let popupButtonManager = PopupButtonManager()
    var popupButtons = [UIButton]()
    var alertController = AlertManager()
    var recipeImage: UIImage?
    var saveImageManger = SaveImageManager()
    var recipeTitle: String?
    var selectedDate = ""
    let formatter = DateFormatter()
    var dateManager = DataFormatManager()
    var stepImages = [UIImage]()
    var stepDescriptions = [String]()
    var nutrientsValue: [Float] = [0.0, 0.0]
    var nutrientsName = ["卡路里", "脂肪"]
    var ingredientName = [String]()
    var ingredientWeight = [Float]()
    let realmManager = RealmManager()
    
    
    //key: AddRecipeInformationTextFieldDidEndEditing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //addRecipeInformationTable.allowsSelection = false
        addRecipeInformationTable.estimatedRowHeight = 243
        addRecipeInformationTable.rowHeight = UITableViewAutomaticDimension
        popupButtons = popupButtonManager.addButton(with: [#imageLiteral(resourceName: "camera"),#imageLiteral(resourceName: "pig"),#imageLiteral(resourceName: "cabbage"),#imageLiteral(resourceName: "iTunesArtwork")], on: self.view)
        popupButtons[0].addTarget(self, action: #selector(mainButtonAction(_:)), for: .touchUpInside)
        popupButtons[1].addTarget(self, action: #selector(popupButton1Action(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(getTitle(notification:)), name: NSNotification.Name(rawValue: "AddRecipeInformationTextFieldDidEndEditing"), object: nil)
    }
    
    @objc func getTitle(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let text = userInfo["text"] as? String else {return}
        self.recipeTitle = text
    }
    
    @objc func mainButtonAction(_ sender: UIButton) {
        popupButtonManager.mainButtonSelected = !popupButtonManager.mainButtonSelected
        if popupButtonManager.mainButtonSelected {
            popupButtonManager.showButtons(on: self.view)
        } else {
            popupButtonManager.hideButtons(on: self.view)
        }
    }
    
    
    @objc func popupButton1Action(_ sender: UIButton) {
        popupButtonManager.hideButtons(on: self.view)
        popupButtonManager.mainButtonSelected = !popupButtonManager.mainButtonSelected
        
        let textViewIsEmpty = checkTextViewIsEmpty()
        let textFieldIsEmpty = checkTextFieldIsEmpty()
        
        if textViewIsEmpty || textFieldIsEmpty {
            alertController.showAlert(viewController: self)
        } else {
            //save data into coreData and fileManager
            getDataFromChildViewControllers()
            let recipe = saveData()
            if let recipeCalendarModel = recipe {
                realmManager.saveUserCreatedRecipe(createdRecipe: recipeCalendarModel)
            }
            if let image = self.recipeImage, let title = self.recipeTitle {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CreatedRecipe"), object: nil, userInfo: ["createdRecipeImage": image, "createdRecipeTitle": title])
            }
            self.navigationController?.popToRootViewController(animated: true)
            
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
            if let recipeImage = self.recipeImage {
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
    
    
    func getDataFromChildViewControllers() {
        self.stepDescriptions = []
        self.stepImages = []
        self.ingredientName = []
        self.ingredientWeight = []
        self.nutrientsValue = [0.0, 0.0]
        
        for index1 in 0...self.rowControllerArray.count-1 {
            for childViewController in self.rowControllerArray[index1] {
                if let vc = childViewController as? InputTextViewController {
                    self.stepDescriptions.append(vc.textView.text)
                } else if let vc = childViewController as? ImagePickerViewController {
                    if let image = vc.image.image {
                        self.stepImages.append(image)
                    }
                } else if let vc = childViewController as? SliderViewController {
                    switch vc.sliderView.sliderDescription.text {
                    case "卡路里":
                        self.nutrientsValue[0] = vc.sliderView.slider.value
                    case "脂肪":
                        self.nutrientsValue[1] = vc.sliderView.slider.value
                    default:
                        print("case is not completed")
                    }
                } else if let vc = childViewController as? NutrientsEditViewController {
                    if let ingredientName = vc.nutrientsEditView.ingredientTextField.text,
                        let ingredientWeightText = vc.nutrientsEditView.weightTextField.text,
                        let ingredientWeight = Float(ingredientWeightText) {
                        self.ingredientName.append(ingredientName)
                        self.ingredientWeight.append(ingredientWeight)
                    }
                }
            }
        }
        
//        for childViewController in self.childViewControllers {
//            if let vc = childViewController as? InputTextViewController {
//                self.stepDescriptions.append(vc.textView.text)
//            } else if let vc = childViewController as? ImagePickerViewController {
//                if let image = vc.image.image {
//                    self.stepImages.append(image)
//                }
//            } else if let vc = childViewController as? SliderViewController {
//                switch vc.sliderView.sliderDescription.text {
//                case "卡路里":
//                    self.nutrientsValue[0] = vc.sliderView.slider.value
//                case "脂肪":
//                    self.nutrientsValue[1] = vc.sliderView.slider.value
//                default:
//                    print("case is not completed")
//                }
//            } else if let vc = childViewController as? NutrientsEditViewController {
//                if let ingredientName = vc.nutrientsEditView.ingredientTextField.text,
//                    let ingredientWeightText = vc.nutrientsEditView.weightTextField.text,
//                    let ingredientWeight = Float(ingredientWeightText) {
//                    self.ingredientName.append(ingredientName)
//                    self.ingredientWeight.append(ingredientWeight)
//                }
//            }
//        }
    }
    
    func checkTextViewIsEmpty()-> Bool {
        var textViewIsEmpty = false
        for childViewController in self.childViewControllers {
            if let vc = childViewController as? InputTextViewController {
                if vc.textView.textColor == UIColor.gray  {
                    vc.textView.textColor = UIColor.red
                    textViewIsEmpty = true
                }
            }
        }
        return textViewIsEmpty
    }
    
    
    func checkTextFieldIsEmpty()-> Bool {
        var textFieldIsEmpty = false
        if let cell = addRecipeInformationTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddRecipeInformationTextFieldCell {
            if (cell.textField.text?.isEmpty)! {
                textFieldIsEmpty = true
                cell.textField.backgroundColor = UIColor.red
            } else {
                self.recipeTitle = cell.textField.text
            }
        }
        return textFieldIsEmpty
    }
    
    
    
    
    func configureTableView() {
        addRecipeInformationTable.delegate = self
        addRecipeInformationTable.dataSource = self
        self.addRecipeInformationTable.separatorStyle = .none
        addRecipeInformationTable.register(UINib(nibName: "AddRecipeInformationTextFieldCell", bundle: nil), forCellReuseIdentifier: "AddRecipeInformationTextFieldCell")
        addRecipeInformationTable.register(UINib(nibName: "AddRecipeInformationTextFieldWithImageCell", bundle: nil), forCellReuseIdentifier: "AddRecipeInformationTextFieldWithImageCell")
        addRecipeInformationTable.register(UINib(nibName: "AddRecipeInformationSliderCell", bundle: nil), forCellReuseIdentifier: "AddRecipeInformationSliderCell")
        addRecipeInformationTable.register(UINib(nibName: "RecipeSearchResultCell", bundle: nil), forCellReuseIdentifier: "RecipeSearchResultCell")
        addRecipeInformationTable.register(UINib(nibName: "NutrientsEditCell", bundle: nil), forCellReuseIdentifier: "NutrientsEditCell")
        self.rowArray[0].append(.textFieldType("菜餚名稱：", "例如：蔥爆牛肉"))
        self.cellHeight.append(50.0)
        self.rowArray[0].append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray[0].append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray[0].append(.sliderType(500.0, "卡路里", "大卡"))
        self.cellHeight.append(100.0)
        self.rowArray[0].append(.sliderType(500.0, "脂肪", "克"))
        self.cellHeight.append(100.0)
        self.rowArray[0].append(.nutrientsEditType)
        self.cellHeight.append(100.0)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight[indexPath.row]
    }
    
    
    override func updateTableView(newHeight: CGFloat, serialNumber: Int) {
        self.cellHeight[serialNumber] = newHeight
        UIView.performWithoutAnimation {
            self.addRecipeInformationTable.beginUpdates()
            self.addRecipeInformationTable.endUpdates()
        }
    }



}
