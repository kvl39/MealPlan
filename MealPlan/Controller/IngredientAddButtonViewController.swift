//
//  IngredientAddButtonViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class IngredientAddButtonViewController: UIViewController {

    let addButtonView = MPIngredientAddButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50.0)
        addButtonView.frame = self.view.frame
        addButtonView.addIngredientButton.addTarget(self, action: #selector(addIngredientButtonDidPressed(_:)), for: .touchUpInside)
        self.view.addSubview(addButtonView)
    }
    
    
    
    
    @objc func addIngredientButtonDidPressed(_ sender: UIButton) {
        //notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addIngredient"), object: nil, userInfo: [:])
    }
    
    

}
