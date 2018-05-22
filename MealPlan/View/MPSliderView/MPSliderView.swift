//
//  MPSliderView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/22.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPSliderView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var sliderDescription: UILabel!
    
    @IBOutlet weak var sliderNumber: UILabel!
    
    @IBOutlet weak var sliderUnit: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MPSliderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
