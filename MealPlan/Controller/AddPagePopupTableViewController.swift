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
    let imageArray: [UIImage] = [#imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "btn_back"), #imageLiteral(resourceName: "iTunesArtwork"), #imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "btn_back"), #imageLiteral(resourceName: "iTunesArtwork")]
    let titleArray: [String] = ["1","2", "3", "4", "5", "6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        configureTableView()
    }

    
    func configureTableView(){

        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        for index in 0...imageArray.count-1 {
            self.rowArray.append(.recipeCellType(imageArray[index], titleArray[index]))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTableCells()
    }
    
    func animateTableCells() {
        let cells = tableView.visibleCells
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        }
        
//        var delay = 0.0
//        for cell in cells {
//            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = .identity
//            })
//            delay = delay + 0.1
//        }
        
        var duration = 0.1 * Double(cells.count)
        for index in 0...cells.count-1 {
            UIView.animate(withDuration: duration - Double(index)*0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                cells[index].transform = .identity
            })
        }
    }
    

}
