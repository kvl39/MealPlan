//
//  SearchViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/7.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit



protocol SearchViewControllerProtocol: class {
    func selectRecipeAnimation(cell: RecipeSearchResultCell, cellRect: CGRect, selectedRecipe: RecipeInformation)
    func deSelectRecipe(cell: RecipeSearchResultCell, deSelectedRecipe: RecipeInformation)
}



class SearchViewController: MPTableViewController, RecipeManagerProtocol {

    var tagArray: AddPageTag!
    var observation: NSKeyValueObservation!
    var recipeManager = RecipeManager()
    //weak var delegate: SearchViewControllerProtocol?
    var searchRecipeModel: RecipeModel?
    var selecteRecipeName = [String]()
    var selectedRecipeImage = [UIImageView]()
    var selectedRecipes = [RecipeCalendarRealmModel]()
    var realmManager = RealmManager()
    var selectedDate = ""
    weak var delegate: AddByClassificationDelegateProtocol?

    @IBOutlet weak var tableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //configureObserver()
        configureTableView()
        self.view.backgroundColor = UIColor.clear
    }
    

    func configureObserver() {
        observation = tagArray.observe(\.tags, options: [.new, .old]) { (tagArray, _) in
            var searchKeyword = "?q="
            if tagArray.tags.count > 0 {
                for index in 0...tagArray.tags.count-1 {
                    if index == 0 {
                        searchKeyword += tagArray.tags[0]
                    } else {
                        searchKeyword += "%26" + tagArray.tags[index]
                    }
                }
                searchKeyword += "&app_id=f15e641c&app_key=cf64c20f394531bb6c9669f48bb0932f&to=7"
                self.recipeManager.getRecipe(keyWord: searchKeyword)
            } else {
                self.rowArray = []
                self.tableView.reloadData()
            }
        }
    }
    
    
    func generateSearchPath() ->String? {
        var searchKeyword = "?q="
        if tagArray.tags.count > 0 {
            for index in 0...tagArray.tags.count-1 {
                if index == 0 {
                    searchKeyword += tagArray.tags[0]
                } else {
                    searchKeyword += "%26" + tagArray.tags[index]
                }
            }
            searchKeyword += "&app_id=f15e641c&app_key=cf64c20f394531bb6c9669f48bb0932f"
            return searchKeyword
        }
        return nil
    }
    
    func startSearching() {
        if let searchPath = generateSearchPath() {
            self.recipeManager.getRecipe(keyWord: searchPath)
        } else {
            self.rowArray = []
            self.tableView.reloadData()
            if let parentVC = self.parent as? AddByClassificationViewController {
                parentVC.initialConfigueViews()
            }
        }
        
    }

    
    
    func configureTableView() {
        tableView.register(UINib(nibName: "RecipeSearchResultCell", bundle: nil), forCellReuseIdentifier: "RecipeSearchResultCell")
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        backgroundView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = backgroundView
        self.tableView.contentInset = UIEdgeInsets(top: 260, left: 0, bottom: 0, right: 0)
    }

    
    
    @objc override func selectRecipeAction(_ sender: UIButton) {
        //toggle select button
        guard let selected = sender.currentImage?.isEqual(UIImage(imageLiteralResourceName: "success_green")) else {return}
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? RecipeSearchResultCell,
              let cellImage = cell.recipeImage.image,
              let cellTitle = cell.recipeTitle.text else {return}
        if self.rowArray.count == 0 {
            self.rowArray.append([])
        }
        self.rowArray[0][sender.tag] = .recipeSearchCellType(nil, cellImage, cellTitle, !selected, true)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        
        guard let searchResult = self.searchRecipeModel,
            let selectedHits = searchResult.hits[sender.tag] as? hits,
            let selectedRecipe = selectedHits.recipe as? RecipeInformation,
            let selectedRecipeInCalendarFormat = self.realmManager.recipeFormatTranslation(from: selectedRecipe, in: self.selectedDate) else {return}
        
        
        
        if selected { //remove from selected
            guard let index = self.selecteRecipeName.index(of: cellTitle) else {return}
            self.selecteRecipeName.remove(at: index)
            self.selectedRecipes.remove(at: index)
            self.selectedRecipeImage.remove(at: index)
        } else {
            self.selecteRecipeName.append(cellTitle)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
            imageView.image = cellImage
            self.selectedRecipeImage.append(imageView)
            self.selectedRecipes.append(selectedRecipeInCalendarFormat)
        }
        print(self.selecteRecipeName)
        
        
        //select animation
//        guard let searchResult = self.searchRecipeModel,
//            let selectedHits = searchResult.hits[sender.tag] as? hits,
//            let selectedRecipe = selectedHits.recipe as? RecipeInformation else {return}
//        if !selected {
//            let cellRectInTable = tableView.rectForRow(at: indexPath)
//            let cellInSuperView = tableView.convert(cellRectInTable, to: nil)
//            self.delegate?.selectRecipeAnimation(cell: cell, cellRect: cellInSuperView, selectedRecipe: selectedRecipe)
//        } else {
//            self.delegate?.deSelectRecipe(cell: cell, deSelectedRecipe: selectedRecipe)
//        }
    }

    
    
    func manager(_ manager: RecipeManager, didGet products: RecipeModel) {
        self.rowArray = []
        self.searchRecipeModel = products
        for index in 0..<products.hits.count {
            if self.rowArray.count == 0 {
                self.rowArray.append([])
            }
            var cellSelected = false
            if self.selecteRecipeName.contains(products.hits[index].recipe.label) {
                cellSelected = true
            }
            self.rowArray[0].append(
            .recipeSearchCellType(products.hits[index].recipe.image.absoluteString, nil, products.hits[index].recipe.label, cellSelected, false))
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
            if let parentVC = self.parent as? AddByClassificationViewController {
                parentVC.didGetSearchResult()
            }
        }
        
    }
    
    

    func manager(_ manager: RecipeManager, didFailWith error: MPError) {
        //show no results!
        DispatchQueue.main.async {
            if let parentVC = self.parent as? AddByClassificationViewController {
                parentVC.failToGetSearchResult()
            }
        }
    }
    
    
    
    func confirmSelection() {
        var selectedRecipeCache = [RecipeCalendarRealmModel]()
        selectedRecipeCache = self.selectedRecipes
        self.realmManager.updateRecipe(recipeArray: self.selectedRecipes, dateString: self.selectedDate)
        self.delegate?.reloadData(addedRecipeImageView: self.selectedRecipeImage, addedRecipeTitle: self.selecteRecipeName)
    }
}


extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -1 * tableView.contentOffset.y
        let height = min(max(y,100), 260)
        tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        let moveDistance = 260 - y
        print("offset:\(y)")
        if let parentVC = self.parent as? AddByClassificationViewController {
            parentVC.adjustView(contentInsetY: moveDistance)
        }
    }
}
