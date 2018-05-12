//
//  AddPageHistoryController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/3.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPageHistoryController: MPTableViewController {

    @IBOutlet weak var tableView: UITableView!
    var imageArray = [UIView]()
    var titleArray = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
    }

    
    
    func configureTableView() {
        tableView.register(UINib(nibName: "HorizontalCollectionView", bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        self.rowArray.append(.horizontalCollectionViewType(imageArray, titleArray))
    }

    
    
    func generateViewWithImage(image: UIImage) -> UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }
    
    

    func selectAnimationDidFinish(animationImage: UIImage, animationString: String) {
        var indexPath = IndexPath(row: 0, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? HorizontalCollectionView else {return}
        indexPath = IndexPath(item: 0, section: 0)
        cell.viewArray.insert(generateViewWithImage(image: animationImage), at: 0)
        cell.titleArray.insert(animationString, at: 0)
        cell.horizontalCollectionView.insertItems(at: [indexPath])
    }
}
