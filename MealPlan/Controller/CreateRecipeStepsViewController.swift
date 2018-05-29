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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollStepsView()
    }

    func configureScrollStepsView() {
        scrollStepsView.delegate = self
        scrollStepsView.contentSize.width = 4 * self.view.frame.width
        scrollStepsView.isPagingEnabled = true
        
        for index in 0..<numberOfSteps {
            let view = UIView(frame: CGRect(x: 10 + self.view.frame.width * CGFloat(index), y: 0, width: self.view.frame.width - 20, height: self.view.frame.height))
            view.backgroundColor = UIColor.red
            self.scrollStepsView.addSubview(view)
        }
    }
    
    

}
