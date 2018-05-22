//
//  ImagePickerViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/20.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    lazy var sliderView = MPSliderView()
    var sliderMax: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame)
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.view.backgroundColor = UIColor.blue
        self.view.addSubview(sliderView)
        sliderView.frame = self.view.frame
        sliderView.slider.addTarget(self, action: #selector(onSliderChange), for: .valueChanged)
    }
    
    func resetSliderMax() {
        sliderView.slider.maximumValue = Float(sliderMax)
    }
    
    @objc func onSliderChange() {
        sliderView.sliderNumber.text = String(sliderView.slider.value)
    }
    
    
}

