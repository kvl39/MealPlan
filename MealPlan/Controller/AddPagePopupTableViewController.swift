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
    var animateTableCellIsShown = false

    var recipeClass: RecipeClass = RecipeClassLayer0()

    //let imageArray: [UIImage] = [#imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "btn_back"), #imageLiteral(resourceName: "iTunesArtwork"), #imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "btn_back"), #imageLiteral(resourceName: "iTunesArtwork")]
    //let titleArray: [String] = ["1","2", "3", "4", "5", "6"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
        self.navigationController?.navigationBar.isHidden = true
    }

    func configureTableView() {

        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")

        for index in 0...recipeClass.recipeTitle.count-1 {
            self.rowArray.append(.recipeCellType(recipeClass.recipeImage[index], recipeClass.recipeTitle[index]))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.animateTableCellIsShown == false {
            animateTableCells()
        }
    }

    func animateTableCells() {
        let cells = tableView.visibleCells

        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        }

        let duration = 0.25 * Double(cells.count)
        for index in 0...cells.count-1 {
            UIView.animate(withDuration: duration - Double(index)*0.1, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                cells[index].transform = .identity
            })
        }
        self.animateTableCellIsShown = true
    }

    func animateOutTableCells() {
        let cells = tableView.visibleCells

        for cell in cells {
            //cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            cell.transform = .identity
        }

        let duration = 0.2 * Double(cells.count)
        for index in 0...cells.count-1 {
            UIView.animate(withDuration: duration - Double(index)*0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                //cells[index].transform = .identity
                cells[index].transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            })
        }
        self.animateTableCellIsShown = false
        self.navigationController?.popToRootViewController(animated: false)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.recipeClass.childArray.count > 0 {
            //push to next table view
            guard let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddPagePopupTableViewController") as? AddPagePopupTableViewController else {return}
            self.navigationController!.pushViewController(vc, animated: true)
            vc.recipeClass = self.recipeClass.childArray[indexPath.row]
            vc.animateTableCellIsShown = true
        } else {
            //add a tag
            self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTag"), object: nil, userInfo: ["tag": self.recipeClass.recipeTitle[indexPath.row], "tagEnglish": self.recipeClass.recipeTitleEnglish[indexPath.row]])
        }

    }

}
