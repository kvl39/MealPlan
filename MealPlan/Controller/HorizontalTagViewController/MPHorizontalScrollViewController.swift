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
    var rightButton = UIButton()
    var leftButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 20, height: 250)
        configureScrollView()
         configureSearchButton()
        self.view.backgroundColor = UIColor.clear
        addLeftRightIndicator()
        leftButton.alpha = 0
        rightButton.alpha = 1
    }
    
    func configureSearchButton() {
        horizontalScrollView.searchButton.addTarget(self, action: #selector(searchButtonDidPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func searchButtonDidPressed(sender: UIButton) {
        if let parentVC = self.parent as? AddByClassificationViewController {
            parentVC.startSearch()
        }
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
            //parentVC.updateTagView()
        }
    }
    
    func getSelectedTag(tagControllerNumber: Int, tagIndex: Int) {
        if let parentVC = self.parent as? AddByClassificationViewController{
            let selectedTag = self.tagData[tagControllerNumber][tagIndex-10]
            //parentVC.updateTextView(selectedTag: selectedTag)
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
            tagController.tagControllerNumber = index
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
            label.font = UIFont(name: "PingFangTC-Thin", size: 30)
            //label.font = UIFont.boldSystemFont(ofSize: 25.0)
            label.textColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
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
    
    func addLeftRightIndicator() {
        rightButton = UIButton(frame: CGRect(x: view.frame.width - 15, y: view.frame.height/2, width: 20, height: 20))
        rightButton.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
        rightButton.addTarget(self, action: #selector(toRight(sender:)), for: .touchUpInside)
        self.view.addSubview(rightButton)
        
        leftButton = UIButton(frame: CGRect(x: 15, y: view.frame.height/2, width: 20, height: 20))
        leftButton.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        leftButton.addTarget(self, action: #selector(toLeft(sender:)), for: .touchUpInside)
        self.view.addSubview(leftButton)
    }
    
    @objc func toRight(sender: UIButton) {
        let originalContentOffset = horizontalScrollView.horizontalScrollView.contentOffset
        let moveTo = CGPoint(x: originalContentOffset.x + horizontalScrollView.horizontalScrollView.frame.width, y: originalContentOffset.y)
        self.horizontalScrollView.horizontalScrollView.setContentOffset(moveTo, animated: true)
    }
    
    @objc func toLeft(sender: UIButton) {
        let originalContentOffset = horizontalScrollView.horizontalScrollView.contentOffset
        let moveTo = CGPoint(x: originalContentOffset.x - horizontalScrollView.horizontalScrollView.frame.width, y: originalContentOffset.y)
        self.horizontalScrollView.horizontalScrollView.setContentOffset(moveTo, animated: true)
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
            let paging = Int((horizontalScrollView.horizontalScrollView.contentOffset.x + horizontalScrollView.horizontalScrollView.frame.width)/self.view.frame.width)
            print("sss paging:\(paging)")
            if paging == 0 {
                leftButton.alpha = 0
                rightButton.alpha = 1
            } else if paging == numberOfScrolls-1 {
                leftButton.alpha = 1
                rightButton.alpha = 0
            } else {
                leftButton.alpha = 1
                rightButton.alpha = 1
            }
        }
    }
    
}
