//
//  MPScrollNavigationViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/29.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPScrollNavigationViewController: UIViewController {

    
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step4Label: UILabel!
    
    
    lazy var scrollBar = UIView(frame: CGRect(x: 30, y: 33, width: 50, height: 5))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureToStepLabels()
        scrollBar.backgroundColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
        scrollBar.frame = CGRect(x: 30, y: 33, width: ((self.view.frame.width-150)/4), height: 5)
        self.view.addSubview(scrollBar)
        step1Label.textColor = UIColor.black
    }
    
    func addGestureToStepLabels() {
        step1Label.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapStep1(sender:)))
        step1Label.addGestureRecognizer(tap1)
        
        step2Label.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapStep2(sender:)))
        step2Label.addGestureRecognizer(tap2)
        
        step3Label.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapStep3(sender:)))
        step3Label.addGestureRecognizer(tap3)
        
        step4Label.isUserInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapStep4(sender:)))
        step4Label.addGestureRecognizer(tap4)
    }
    
    @objc func tapStep1(sender: UITapGestureRecognizer) {
        print("tapped1")
    }
    
    @objc func tapStep2(sender: UITapGestureRecognizer) {
        print("tapped2")
        if let parentVC = parent as? CreateRecipeStepsViewController {
            parentVC.scrollToLeft()
        }
    }
    
    @objc func tapStep3(sender: UITapGestureRecognizer) {
        print("tapped3")
    }
    
    @objc func tapStep4(sender: UITapGestureRecognizer) {
        print("tapped4")
    }
    
    func updateScrollBarPosition(newX: CGFloat, page: Int) {
        print("newX:\(newX)")
        scrollBar.frame.origin = CGPoint(x: newX, y: scrollBar.frame.origin.y)
        switch page {
        case 0:
            step1Label.textColor = UIColor.black
            step2Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step3Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step4Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
        case 1:
            step2Label.textColor = UIColor.black
            step1Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step3Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step4Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
        case 2:
            step3Label.textColor = UIColor.black
            step1Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step2Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step4Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
        case 3:
            step4Label.textColor = UIColor.black
            step1Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step2Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
            step3Label.textColor = UIColor(red: 121/255.0, green: 121/255.0, blue: 121/255.0, alpha: 1.0)
        default: return
        }
    }


}
