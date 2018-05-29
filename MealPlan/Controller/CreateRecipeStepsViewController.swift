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
    @IBOutlet weak var topImageView: UIImageView!
    
    
    
    var currentStep = 1
    var numberOfSteps = 4
    var stepIndicationWidth: CGFloat = 0.0
    var controllersArray: [ViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollStepsView()
        stepIndicationWidth = 0.25 * (self.view.frame.width - 150)
        topImageView.backgroundColor = UIColor(red: 253/255.0, green: 216/255.0, blue: 53/255.0, alpha: 1)
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
        
//        var cameraViewController = CameraViewController()
//        addChildViewController(cameraViewController)
//        cameraViewController.view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height-120)
        //self.view.addSubview(cameraViewController.view)
//        didMove(toParentViewController: cameraViewController)
        
        
    }

}

extension CreateRecipeStepsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollStepsView {
            print("scroll view offset:\(scrollView.contentOffset)")
        }
        
        let page = Int(scrollView.contentOffset.x / self.view.frame.width)
        let newX = (0.25 - (7.5/self.view.frame.width)) * scrollView.contentOffset.x + 30
        
        for child in childViewControllers {
            if let child = child as? MPScrollNavigationViewController {
                child.updateScrollBarPosition(newX: newX, page: page)
            }
        }
        
    }
    
}
