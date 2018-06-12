//
//  MPTagViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/7.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

extension String {
    func widthOfString(using font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}



class MPTagViewController: UIViewController {

    var tagArray: AddPageTag!
    var tags: [String] = []
    var observation: NSKeyValueObservation!
    lazy var hintLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureObserver()
        configureHints()
        self.view.backgroundColor = UIColor.clear
    }
    
    func configureHints() {
        hintLabel.text = "Choose Tags to search"
        hintLabel.textColor = UIColor.gray
        hintLabel.font = UIFont(name: "PingFangTC-Light ", size: 13.5)
        hintLabel.frame = CGRect(x: 10, y: 10, width: 280, height: 40)
        self.view.addSubview(hintLabel)
    }
    
    func showHints() {
        hintLabel.alpha = 1
        if let parent = self.parent as? AddByClassificationViewController {

        }
    }
    
    func hideHints() {
        hintLabel.alpha = 0
    }

    func configureObserver() {
        observation = tagArray.observe(\.tags, options: [.new, .old]) { (tagArray, _) in
            self.createTag(onView: self.view, with: tagArray.tags)
        }
    }
    
    

    func createTag(onView view: UIView, with array: [String]) {
        for tempView in view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        
        if array.count == 0 {
            showHints()
            return
        } else {
            hideHints()
        }
        
        
        tags = array
        var xPos: CGFloat = 15.0
        var yPos: CGFloat = 20.0
        var tag: Int = 1

        for data in array {
            //recover to original height first
            let width = data.widthOfString(using: UIFont(name: "Verdana", size: 13.0)!)
            let checkWholeWidth = xPos + width + 13.0 + 25.5
            if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                xPos = 15.0
                yPos += 29.0 + 8.0
            }

            let bgView = UIView(frame: CGRect(x: xPos + 5, y: yPos, width: width + 17.0 + 38.5 - 30.0, height: 29.0))
            bgView.layer.cornerRadius = 14.5
            bgView.backgroundColor = UIColor(red: 201/255.0, green: 132/255.0, blue: 116/255.0, alpha: 1)
            bgView.tag = tag

            let textLabel = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            textLabel.font = UIFont(name: "Verdana", size: 13.0)
            textLabel.text = data
            
            if tag > 1 {
                let andView = UILabel(frame: CGRect(x: xPos, y: yPos - 16.0, width: width, height: bgView.frame.size.height))
                andView.text = "+"
                view.addSubview(andView)
                andView.tag = tag
            }
            
            
            textLabel.textColor = UIColor.white
            bgView.addSubview(textLabel)
            

//            let button = UIButton(type: .custom)
//            button.frame = CGRect(x: bgView.frame.size.width - 2.0 - 23.0,
//                                  y: 3.0, width: 23.0, height: 23.0)
//            button.backgroundColor = UIColor.white
//            button.layer.cornerRadius =  CGFloat(button.frame.size.width)/CGFloat(2.0)
//            button.setImage(#imageLiteral(resourceName: "iTunesArtwork-1"), for: .normal)
//            button.tag = tag
//            button.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)
//            bgView.addSubview(button)
            view.addSubview(bgView)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43) - CGFloat(30)
            tag += 1
        }
        
    }

    
    
    @objc func removeTag(_ sender: UIButton) {
        //tagArray.tags.remove(at: sender.tag-1)
        tags.remove(at: sender.tag-1)
        createTag(onView: self.view, with: self.tags)
        if self.tags.count == 0 {
            self.hintLabel.alpha = 1
        }
        
    }
}
