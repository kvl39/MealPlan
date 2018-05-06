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
    private var finishedLoadingInitialTableCells = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        configureTableView()
        
    }

    
    func configureTableView(){
        
        
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        
        var imageArray = [UIImage]()
        imageArray.append(#imageLiteral(resourceName: "btn_like_normal"))
        imageArray.append(#imageLiteral(resourceName: "iTunesArtwork"))
        
        self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_like_normal"), "1st row"))
        self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_back"), "2nd row"))

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 80/2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
        
    }

}
