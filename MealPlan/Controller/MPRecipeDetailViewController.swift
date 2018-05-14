//
//  MPRecipeDetailViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/13.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailViewController: MPTableViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    var displayImage: UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.image = displayImage
        recipeImage.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = false
        recipeDetailTableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        recipeDetailTableView.delegate = self
        recipeDetailTableView.dataSource = self
    }
}



extension MPRecipeDetailViewController: ZoomingViewController {
    func zoomingImageView() -> UIImageView? {
        return recipeImage
    }
}


extension MPRecipeDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (recipeDetailTableView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        recipeImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
}


