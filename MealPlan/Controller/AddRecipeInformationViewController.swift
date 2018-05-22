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
        }
        
        if let recipeImage = self.recipeImage, let recipeTitle = self.recipeTitle {
            let saveImageSuccess = saveImageManger.saveImage(image: recipeImage, imageFileName: recipeTitle)
            print("success?:\(saveImageSuccess)")
        } else {
            print("heeeer")
            
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
        self.rowArray.append(.textFieldType("菜餚名稱：", "例如：蔥爆牛肉"))
        self.cellHeight.append(50.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray.append(.sliderType(133.0))
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
