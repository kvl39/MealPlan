//
//  AddRecipeInformationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/20.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

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
    var nutrientsValue = [Float]()
    var ingredientName = [String]()
    var ingredientWeight = [Float]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //addRecipeInformationTable.allowsSelection = false
        addRecipeInformationTable.estimatedRowHeight = 243
        addRecipeInformationTable.rowHeight = UITableViewAutomaticDimension
        popupButtons = popupButtonManager.addButton(with: [#imageLiteral(resourceName: "camera"),#imageLiteral(resourceName: "pig"),#imageLiteral(resourceName: "cabbage"),#imageLiteral(resourceName: "iTunesArtwork")], on: self.view)
        popupButtons[0].addTarget(self, action: #selector(mainButtonAction(_:)), for: .touchUpInside)
        popupButtons[1].addTarget(self, action: #selector(popupButton1Action(_:)), for: .touchUpInside)
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
            saveData()
            
        }
        
        if let recipeImage = self.recipeImage, let recipeTitle = self.recipeTitle {
            let saveImageSuccess = saveImageManger.saveImage(image: recipeImage, imageFileName: recipeTitle)
            print("success?:\(saveImageSuccess)")
        }
    }
    
    func saveData() {
        let recipeModel = RecipeCalendarRealmModel()
        guard let addDate = self.dateManager.stringToDate(dateString: selectedDate, to: "yyyy MM dd") else {return}
        recipeModel.recipeDay = addDate
        recipeModel.withSteps = true
        
        let recipeRealmModelWithSteps = RecipeRealmModelWithSteps()
        //recipeRealmModelWithSteps.calories = 
    }
    
    
    func getDataFromChildViewControllers() {
        for childViewController in self.childViewControllers {
            if let vc = childViewControllers as? InputTextViewController {
                self.stepDescriptions.append(vc.textView.text)
            } else if let vc = childViewControllers as? ImagePickerViewController {
                if let image = vc.image.image {
                    self.stepImages.append(image)
                }
            } else if let vc = childViewController as? SliderViewController {
                switch vc.sliderView.sliderDescription.text {
                case "卡路里":
                    self.nutrientsValue.append(vc.sliderView.slider.value)
                default:
                    print("case is not completed")
                }
            } //else if let vc = childViewController as?
        }
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
        self.rowArray.append(.textFieldType("菜餚名稱：", "例如：蔥爆牛肉"))
        self.cellHeight.append(50.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray.append(.sliderType(133.0))
        self.cellHeight.append(100.0)
        self.rowArray.append(.nutrientsEditType)
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
