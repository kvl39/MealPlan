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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //addRecipeInformationTable.allowsSelection = false
        addRecipeInformationTable.estimatedRowHeight = 243
        addRecipeInformationTable.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    func configureTableView() {
        addRecipeInformationTable.delegate = self
        addRecipeInformationTable.dataSource = self
        self.addRecipeInformationTable.separatorStyle = .none
        addRecipeInformationTable.register(UINib(nibName: "AddRecipeInformationTextFieldCell", bundle: nil), forCellReuseIdentifier: "AddRecipeInformationTextFieldCell")
        addRecipeInformationTable.register(UINib(nibName: "AddRecipeInformationTextFieldWithImageCell", bundle: nil), forCellReuseIdentifier: "AddRecipeInformationTextFieldWithImageCell")
        self.rowArray.append(.textFieldType("菜餚名稱：", "例如：蔥爆牛肉"))
        self.cellHeight.append(50.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        self.rowArray.append(.recipeStepType)
        self.cellHeight.append(243.0)
        
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
