//
//  SearchViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/7.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

//ToDo:
//1. play animation after retrieving search result

import UIKit

protocol SearchViewControllerProtocol: class {
    func selectRecipeAnimation(cell: RecipeSearchResultCell, cellRect: CGRect)
}

class SearchViewController: MPTableViewController, RecipeManagerProtocol {

    var tagArray: AddPageTag!
    var observation: NSKeyValueObservation!
    var recipeManager = RecipeManager()
    weak var delegate: SearchViewControllerProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureObserver()
        configureTableView()
    }
    
    func configureObserver() {
        observation = tagArray.observe(\.tags, options: [.new, .old]) { (tagArray, change) in
            print(tagArray.tags)
            var searchKeyword = "?q="
            if tagArray.tags.count > 0 {
                for index in 0...tagArray.tags.count-1 {
                    if index == 0 {
                        searchKeyword = searchKeyword + tagArray.tags[0]
                    } else {
                        searchKeyword = searchKeyword + "%26" + tagArray.tags[index]
                    }
                }
                searchKeyword = searchKeyword + "&app_id=f15e641c&app_key=cf64c20f394531bb6c9669f48bb0932f&to=5"
                //self.recipeManager.getRecipe(keyWord: searchKeyword)
            } else {
                self.rowArray = []
                self.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        
        tableView.register(UINib(nibName: "RecipeSearchResultCell", bundle: nil), forCellReuseIdentifier: "RecipeSearchResultCell")
        
        //data for test only
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "btn_like_normal"), "testcell", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "success_green"), "testcel2", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "iTunesArtwork"), "testcel3", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "btn_like_normal"), "testcel4", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "btn_like_normal"), "testcel5", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "btn_like_normal"), "testcel6", false))
        self.rowArray.append(.recipeSearchCellType(#imageLiteral(resourceName: "btn_like_normal"), "testcel7", false))
    
    }
    
    @objc override func selectRecipeAction(_ sender : UIButton) {
        print("select tag:\(sender.tag)" )
        
        guard let selected = sender.currentImage?.isEqual(UIImage(imageLiteralResourceName: "success_green")) else {return}
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? RecipeSearchResultCell,
              let cellImage = cell.recipeImage.image,
              let cellTitle = cell.recipeTitle.text else {return}

        self.rowArray[sender.tag] = .recipeSearchCellType(cellImage, cellTitle, !selected)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        
        //2. trigger animation to add to history controller
        
        let cellRectInTable = tableView.rectForRow(at: indexPath)
        let cellInSuperView = tableView.convert(cellRectInTable, to: nil)
        self.delegate?.selectRecipeAnimation(cell: cell, cellRect: cellInSuperView)
        
        
        //3. add to history controller
    }

    
    
    func manager(_ manager: RecipeManager, didGet products: RecipeModel) {
        self.rowArray = []
        for index in 0...products.hits.count-1 {
            self.rowArray.append(.recipeCellType(#imageLiteral(resourceName: "btn_back"), products.hits[index].recipe.label))
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func manager(_ manager: RecipeManager, didFailWith error: MPError) {
        
    }

}
