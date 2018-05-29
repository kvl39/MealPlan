//
//  DrawLineView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DrawLineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw( _ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor.red.cgColor)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 0, y: self.frame.width))
        context!.strokePath()
    }
    
}
