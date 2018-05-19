//
//  DiscoverCardView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/17.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DiscoverCardView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var title: UILabel!

    @IBOutlet var imageArray: [UIImageView]!
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DiscoverCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
    }

}
