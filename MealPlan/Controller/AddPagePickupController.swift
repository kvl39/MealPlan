//
//  AddPagePickupController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/3.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPagePickupController: MPTableViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        configureTableView()
    }
    
    func configureTableView() {
        
        tableView.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        
        var imageArray = [UIView]()
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_selected")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_like_normal")))
        imageArray.append(generateViewWithImage(image: #imageLiteral(resourceName: "btn_back")))
        self.rowArray.append(.horizontalCollectionViewType(imageArray))
        
        
    }
    
    func generateViewWithImage(image: UIImage)->UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

}


extension AddPagePickupController: UICollectionViewDelegateFlowLayout {
    
    
}
