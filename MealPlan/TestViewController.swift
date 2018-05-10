//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import SDWebImage

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
    let realmManager = RealmManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTable.delegate = self
        testTable.dataSource = self

        configureTableView()
        configureAddButton()
        self.navigationController?.navigationBar.isHidden = true
    }
   
    
    func configureAddButton() {
        
        addButton = generateButtonWithConstraint(title: "+", bottomConstraintConstant: -20.0)
        takePictureButton = generateButtonWithConstraint(title: "takePicture", bottomConstraintConstant: -80.0)
        typeButton = generateButtonWithConstraint(title: "type", bottomConstraintConstant: -140.0)
        shareButton = generateButtonWithConstraint(title: "share", bottomConstraintConstant: -200.0)
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
        
        typeButton?.addTarget(self, action: #selector(typeButtonInteraction(_:)), for: .touchUpInside)

    }
    
    @objc func typeButtonInteraction(_ sender: UIButton) {
        hideButton()
        self.addButtonSelected = !self.addButtonSelected
        performSegue(withIdentifier: "PushToAddPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        button.backgroundColor = UIColor.black
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: bottomConstraintConstant)
        view.addConstraints([heightConstraint, widthConstraint, bottomConstraint])
        return button
    }

    func configureTableView(){
        self.testTable.separatorStyle = .none
        testTable.register(UINib(nibName: "CalendarCollectionView", bundle: nil), forCellReuseIdentifier: "CalendarCollectionView")//only for reuse? but if this line is removed, it crashes!
        testTable.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        self.rowArray.append(.calendarCollectionViewType)
       
       var imageArray = [UIView]()
       imageArray.append(pieChartManager.generateViewWithPieChart(value: 90))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
       imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
       var titleArray = ["A","B","C","D","E","F","G"]
       self.rowArray.append(.horizontalCollectionViewType(imageArray, titleArray))
        
        
//        var imageArray2 = [UIView]()
//        imageArray2.append(pieChartManager.generateViewWithPieChart(value: 80))
//        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
//        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
//        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
//        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
//        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
//        self.rowArray.append(.horizontalCollectionViewType(imageArray2))
        
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
        let result = self.realmManager.fetchRecipe(in: date)
        print(result)
        //select date -> show data in card
        guard let fetchResult = result else {return}
        updateDataInTableView(fetchResult: fetchResult)
    }
    
    func updateDataInTableView(fetchResult: [RecipeCalendarRealmModel]) {
        var imageArray2 = [UIView]()
        var titleArray = [String]()
        
        for recipe in fetchResult {
            guard let recipeLabel = recipe.recipeRealmModel?.label,
                  let recipeImageURL = recipe.recipeRealmModel?.image else {return}
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
            imageView.sd_setImage(with: URL(string: recipeImageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (image, error, cacheType, url) in
                guard let error = error else {return}
                print(error)
            }
            
            titleArray.append(recipeLabel)
            imageArray2.append(imageView)
        }
        
        
        self.rowArray[1] = .horizontalCollectionViewType(imageArray2,titleArray)
        
        var indexPath = IndexPath(row: 1, section: 0)
        guard let cell = self.testTable.cellForRow(at: indexPath) as? HorizontalCollectionView else {return}
        cell.horizontalCollectionView.reloadData()
        self.testTable.reloadData()
    }
    
    

}
