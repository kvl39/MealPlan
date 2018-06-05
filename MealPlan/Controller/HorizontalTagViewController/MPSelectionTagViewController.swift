//
//  MPSelectionTagViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPSelectionTagViewController: UIViewController {
    
    var unSelectedTags = [Int]()
    var seletedTags = [Int]()
    var tagControllerNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createTag(with array: [String]) {
        for tempView in self.view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        
        var xPos: CGFloat = 15.0
        var yPos: CGFloat = 20.0
        var tag: Int = 10
        let offset: CGFloat = 15.0
        
        for data in array {
            let width = data.widthOfString(using: UIFont(name: "PingFang TC", size: 16.0)!)
            let checkWholeWidth = xPos + width + 13.0 + 25.5 - offset + 10
            if checkWholeWidth > UIScreen.main.bounds.width - 60.0 {
                xPos = 15.0
                yPos += 29.0 + 8.0
            }

            
            let bgView = UIButton(frame: CGRect(x: xPos, y: yPos, width: width + 17.0 + 38.5 - offset, height: 29.0))
            bgView.layer.cornerRadius = 14.5
            //bgView.backgroundColor = UIColor.clear
            bgView.layer.borderWidth = 2
            bgView.backgroundColor = UIColor.white
            bgView.layer.borderColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1).cgColor
            bgView.addTarget(self, action: #selector(tagDidTouch(sender:)), for: .touchUpInside)
            bgView.tag = tag
            unSelectedTags.append(tag)
            
            let textLabel = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            //textLabel.isUserInteractionEnabled = true
            textLabel.font = UIFont(name: "PingFang TC", size: 16.0)
            textLabel.text = data
            textLabel.textColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
            bgView.addSubview(textLabel)
            
            self.view.addSubview(bgView)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43.0)
            tag += 1
        }
    }
    
    @objc func tagDidTouch(sender: UIButton) {
        if let index =  unSelectedTags.index(of: sender.tag){
            //not selected -> selected
            seletedTags.append(sender.tag)
            unSelectedTags.remove(at: index)
            sender.backgroundColor = UIColor(red: 201/255.0, green: 132/255.0, blue: 116/255.0, alpha: 1)
            if let subView = sender.subviews.first as? UILabel {
                subView.textColor = UIColor.white
            }
        } else if let index = seletedTags.index(of: sender.tag){
            //selected -> unselected
            unSelectedTags.append(sender.tag)
            seletedTags.remove(at: index)
            sender.backgroundColor = UIColor.white
            if let subView = sender.subviews.first as? UILabel {
                subView.textColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
            }
        }
        if let parentVC = self.parent as? MPHorizontalScrollViewController {
            //parentVC.getSelectedTag()
            parentVC.getSelectedTag(tagControllerNumber: self.tagControllerNumber, tagIndex: sender.tag)
        }
    }
    
    @objc func removeTag(_ sender: UIButton) {
        //tagArray.tags.remove(at: sender.tag-1)
        //createTag(onView: self.view, with: tagArray.tags)
    }

}
