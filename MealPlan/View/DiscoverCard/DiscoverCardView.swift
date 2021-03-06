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
    @IBOutlet weak var title: UILabel!
    @IBOutlet var imageArray: [UIImageView]!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var pagingPointArray = [UIView]()
    
    
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
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.clear
        
        self.containerView.layer.cornerRadius = 15
        self.containerView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        
        rightButton.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
        leftButton.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
 
    }
    
    
    func addCustomPaging(pagingNumber: Int) {
        let pagingStackView = UIStackView(frame: CGRect(x: 0, y: Int(self.frame.height - 20), width: pagingNumber*20-10, height: 10))
        pagingStackView.distribution = .fillEqually
        pagingStackView.spacing = 10
        print("paging number:\(pagingNumber)")
        for index in 0..<pagingNumber {
            let pagingPoint = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            pagingPoint.backgroundColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
            self.pagingPointArray.append(pagingPoint)
            pagingStackView.addArrangedSubview(pagingPoint)
        }
        pagingStackView.frame.origin = CGPoint(x: self.contentView.center.x-0.5*pagingStackView.frame.width, y: self.frame.height-20)
        print("self center:\(self.contentView.center.x)")
        print("pagingStackView width:\(pagingStackView.frame.width)")
        self.addSubview(pagingStackView)
    }
    
    
    func updatePaging(newPagingNumber: Int) {
        for pagingPoint in self.pagingPointArray {
            pagingPoint.backgroundColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
        }
        self.pagingPointArray[newPagingNumber].backgroundColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
    }

}
