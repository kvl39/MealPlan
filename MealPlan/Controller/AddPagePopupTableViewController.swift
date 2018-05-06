//
//  AddPagePopupTableViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/6.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPagePopupTableViewController: MPTableViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        configureTableView()
        
    }

    
    func configureTableView(){
        
        
        tableView.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        
        
        var imageArray = [UIView]()
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(imageArray))
        
        
        var imageArray2 = [UIView]()
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray2.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(imageArray2))
        
        
    }
    
    func generateViewWithImage(image: UIImage)->UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    

}
