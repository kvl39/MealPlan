//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import Charts

class TestViewController: MPTableViewController {

    
    @IBOutlet weak var testTable: UITableView!
    let pieChartManager = MPPieChart()
    var addButtonSelected = true
    var addButton: UIButton?
    var takePictureButton: UIButton?
    var typeButton: UIButton?
    var shareButton: UIButton?
    var addButtonRightConstraint: NSLayoutConstraint?
    var takePictureButtonRightConstraint: NSLayoutConstraint?
    var typeButtonRightConstraint: NSLayoutConstraint?
    var shareButtonRightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTable.delegate = self
        testTable.dataSource = self

        configureTableView()
        configureAddButton()
        
    }
    
    func configureAddButton() {
        
        addButton = generateButtonWithConstraint(title: "+", bottomConstraintConstant: -20.0)
        takePictureButton = generateButtonWithConstraint(title: "takePicture", bottomConstraintConstant: -60.0)
        typeButton = generateButtonWithConstraint(title: "type", bottomConstraintConstant: -100.0)
        shareButton = generateButtonWithConstraint(title: "share", bottomConstraintConstant: -140.0)
        addButtonRightConstraint = NSLayoutConstraint(item: addButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: -20)
        takePictureButtonRightConstraint = NSLayoutConstraint(item: takePictureButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)
        typeButtonRightConstraint = NSLayoutConstraint(item: typeButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)
        shareButtonRightConstraint = NSLayoutConstraint(item: shareButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)
        
        if let addButtonRightConstraint = addButtonRightConstraint,
           let takePictureButtonRightConstraint = takePictureButtonRightConstraint,
           let typeButtonRightConstraint = typeButtonRightConstraint,
           let shareButtonRightConstraint = shareButtonRightConstraint {
            view.addConstraints([addButtonRightConstraint, takePictureButtonRightConstraint, typeButtonRightConstraint, shareButtonRightConstraint])
        }
        
        if let addButton = addButton {
            addButton.addTarget(self, action: #selector(addButtonInteraction), for: .touchUpInside)
        }

    }
    
    @objc func addButtonInteraction(_ sender : UIButton) {
        if self.addButtonSelected {
            showButton()
        } else {
            hideButton()
        }
        self.addButtonSelected = !self.addButtonSelected
    }
    
    func showButton() {
//        UIView.animate(withDuration: 0.5) {
//            //self.takePictureButton?.alpha = 1
//            self.typeButton?.alpha = 1
//            self.shareButton?.alpha = 1
//
//            //self.takePictureButtonRightConstraint?.constant = -20
//            self.typeButtonRightConstraint?.constant = -20
//            self.shareButtonRightConstraint?.constant = -20
//            self.view.layoutIfNeeded()
//        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.takePictureButton?.alpha = 1
            self.takePictureButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.typeButton?.alpha = 1
            self.typeButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.shareButton?.alpha = 1
            self.shareButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func hideButton() {
        UIView.animate(withDuration: 0.5) {
            self.takePictureButton?.alpha = 0
            self.typeButton?.alpha = 0
            self.shareButton?.alpha = 0
            
            self.takePictureButtonRightConstraint?.constant = 100
            self.typeButtonRightConstraint?.constant = 100
            self.shareButtonRightConstraint?.constant = 100
            self.view.layoutIfNeeded()
        }
    }
    
    func generateButtonWithConstraint(title: String, bottomConstraintConstant: CGFloat)-> UIButton {
        
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        //button.setImage(#imageLiteral(resourceName: "btn_like_selected"), for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.green
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 50.0, height: 50.0)
//        let rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: rightConstraintConstant)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: bottomConstraintConstant)
        view.addConstraints([bottomConstraint])
        return button
    }

    func configureTableView(){
        
        testTable.register(UINib(nibName: "CalendarCollectionView", bundle: nil), forCellReuseIdentifier: "CalendarCollectionView")//only for reuse? but if this line is removed, it crashes!
        testTable.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        self.rowArray.append(.calendarCollectionViewType)
       
       var imageArray = [UIView]()
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       self.rowArray.append(.horizontalCollectionViewType(imageArray))
        
        
        var imageArray2 = [UIView]()
        imageArray2.append(pieChartManager.generateViewWithPieChart(value: 80))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(imageArray2))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectDate(notification:)), name: NSNotification.Name(rawValue: "SelectDate"), object: nil)
        
    }
    
    func generateViewWithImage(image: UIImage)->UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    @objc func onSelectDate(notification:Notification)
    {
        guard let userInfo = notification.userInfo,
              let date = userInfo["date"] as? String else {return}
        print(date)
    }
    

}
