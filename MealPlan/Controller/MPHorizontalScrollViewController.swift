//
//  MPHorizontalScrollViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/26.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPHorizontalScrollViewController: UIViewController, UIScrollViewDelegate {

    let horizontalScrollView = MPHorizontalScrollView()
    let viewArray = [UIView]()
    let numberOfScrolls = 3
    let scrollViewLabel = ["Meat", "Vegatable", "Fruit"]
    let viewTagOffset = 50
    var tagControllers = [MPSelectionTagViewController]()
    var selectedTags = [String]()
    let tagData = [
        ["pork", "beef", "chicken", "fish", "lamb", "turkey", "shrimp"],
        ["cabbage", "spinach", "broccoli", "beans", "celery", "potato"],
        ["banana","apple","orange"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 200)
        configureScrollView()
        self.view.backgroundColor = UIColor.clear
    }
    
    
    func getSelectedTags() {
        selectedTags = []
        for index in 0..<tagControllers.count {
            for tagNumber in tagControllers[index].seletedTags {
                 selectedTags.append(tagData[index][tagNumber-10])
            }
        }
        if let parentVC = self.parent as? AddByClassificationViewController{
            parentVC.selectedTags = selectedTags
            parentVC.updateTagView()
        }
    }

    func configureScrollView() {
        self.horizontalScrollView.horizontalScrollView.delegate = self
        self.view.addSubview(horizontalScrollView)
        horizontalScrollView.frame = self.view.frame
        horizontalScrollView.horizontalScrollView.contentSize.width = self.view.frame.width * CGFloat(numberOfScrolls)
        for index in 0...numberOfScrolls-1 {
            let view = UIView(frame: CGRect(x: 10 + self.view.frame.width * CGFloat(index), y: 40, width: self.view.frame.width - 20, height: horizontalScrollView.horizontalScrollView.frame.height-40))
            view.tag = index + viewTagOffset
            self.horizontalScrollView.horizontalScrollView.addSubview(view)
            
            //tag controller
            let tagController = MPSelectionTagViewController()
            self.tagControllers.append(tagController)
            addChildViewController(tagController)
            view.addSubview(tagController.view)
            tagController.view.frame.size = CGSize(width: view.frame.width - 40, height: view.frame.height)
            tagController.view.frame.origin = CGPoint(x: tagController.view.frame.origin.x + CGFloat(20), y: 0)
            tagController.createTag(with: tagData[index])
            tagController.didMove(toParentViewController: self)
            
            //label
            let label = UILabel(frame: CGRect(x: 0, y: 5, width: 0, height: 40))
            label.text = scrollViewLabel[index]
            label.font = UIFont(name: "PingFangTC-Light ", size: 30)
            label.font = UIFont.boldSystemFont(ofSize: 25.0)
            label.textColor = UIColor(red: 201/255.0, green: 132/255.0, blue: 116/255.0, alpha: 1)
            label.sizeToFit()
            label.tag = 10 + index + viewTagOffset
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapTitle(sender:)))
            
            label.addGestureRecognizer(tap)
            if index == 0 {
                label.center.x = view.center.x
            } else {
                label.center.x = view.center.x - self.horizontalScrollView.horizontalScrollView.frame.width / 2
            }
            
            self.horizontalScrollView.horizontalScrollView.addSubview(label)
        }
    }
    
    @objc func tapTitle(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let locationx = sender.location(in: self.view).x
            print("sender location:\(locationx)")
            let originalContentOffset = horizontalScrollView.horizontalScrollView.contentOffset
            if locationx < 50 {
                print("go left")
                let moveTo = CGPoint(x: originalContentOffset.x - horizontalScrollView.horizontalScrollView.frame.width, y: originalContentOffset.y)
                self.horizontalScrollView.horizontalScrollView.setContentOffset(moveTo, animated: true)
            } else if locationx > self.view.frame.width - 50 {
                print("go right")
                let moveTo = CGPoint(x: originalContentOffset.x + horizontalScrollView.horizontalScrollView.frame.width, y: originalContentOffset.y)
                self.horizontalScrollView.horizontalScrollView.setContentOffset(moveTo, animated: true)
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.horizontalScrollView.horizontalScrollView{
            for i in 0..<numberOfScrolls {
                let label = horizontalScrollView.horizontalScrollView.viewWithTag(i + 10 + viewTagOffset) as! UILabel
                let view = horizontalScrollView.horizontalScrollView.viewWithTag(i + viewTagOffset) as! UIView
                let scrollContentOffset = horizontalScrollView.horizontalScrollView.contentOffset.x + horizontalScrollView.horizontalScrollView.frame.width
                
                var viewOffsets = (view.center.x - horizontalScrollView.horizontalScrollView.bounds.width / 4) - scrollContentOffset
                label.center.x = scrollContentOffset - ((horizontalScrollView.horizontalScrollView.bounds.width/4 - viewOffsets)/2)
                
            }
        }
    }
    
}
