//
//  MPHorizontalScrollView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPHorizontalScrollView: UIView {

    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MPHorizontalScrollView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.horizontalScrollView.isPagingEnabled = true
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        shadowEffect()
        configureButton()
    }
    
    
    func shadowEffect() {
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        contentView.layer.cornerRadius = 3.0
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.8
    }
    
    func configureButton() {
        self.searchButton.layer.cornerRadius = 10
        self.searchButton.clipsToBounds = true
    }
}
