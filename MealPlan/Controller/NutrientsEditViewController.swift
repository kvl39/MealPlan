//
//  NutrientsEditViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/22.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class NutrientsEditViewController: UIViewController {

    lazy var nutrientsEditView = MPNutrientsEditView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.view.addSubview(nutrientsEditView)
        nutrientsEditView.frame = self.view.frame
    }
    
    
}
