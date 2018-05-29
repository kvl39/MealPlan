//
//  MPScrollNavigationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/29.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPScrollNavigationViewController: UIViewController {

    let scrollBar = UIView(frame: CGRect(x: 0, y: 70, width: 50, height: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollBar()
    }
    
    func configureScrollBar() {
        scrollBar.backgroundColor = UIColor.red
        self.view.addSubview(scrollBar)
    }
    
    func updateScrollBarPosition(newX: CGFloat) {
        scrollBar.frame.origin = CGPoint(x: newX, y: scrollBar.frame.origin.y)
    }


}
