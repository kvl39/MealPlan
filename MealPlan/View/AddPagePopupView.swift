//
//  AddPagePopupView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/12.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPagePopupView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {return}
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -200),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.frame.size.height-350),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -70)
            ])
    }
}
