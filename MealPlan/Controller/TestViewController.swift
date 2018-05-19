//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/19.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var popupButtonManager = PopupButtonManager()
    var popupButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        print("button1 selected")
    }
    
    

}
