//
//  GradientImageView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit


class GradientImageView: UIImageView {
    
    var gradientLayer: CAGradientLayer
    
    required init?(coder aDecoder: NSCoder) {
        gradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        gradientLayer = CAGradientLayer()
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        gradientLayer.frame = self.frame
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        let colors: [CGColor] = [UIColor.clear.cgColor,
                                 UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
        gradientLayer.colors = colors
        gradientLayer.locations = [0,0.8]
        gradientLayer.isOpaque = false
        
        self.layer.addSublayer(gradientLayer)
    }
}



class GradientImageViewUpSideDown: UIImageView {
    
    var gradientLayer: CAGradientLayer
    
    required init?(coder aDecoder: NSCoder) {
        gradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        gradientLayer = CAGradientLayer()
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        gradientLayer.frame = self.frame
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        let colors: [CGColor] = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor,
                                 UIColor.clear.cgColor]
        gradientLayer.colors = colors
        gradientLayer.locations = [0,0.5]
        gradientLayer.isOpaque = false
        
        self.layer.addSublayer(gradientLayer)
    }
}
