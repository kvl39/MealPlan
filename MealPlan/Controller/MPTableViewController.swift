//
//  MPTableViewController.swift
//
//
//  Created by Liao Kevin on 2018/5/1.
//

import UIKit


enum MPTableViewCellType {
    case horizontalCollectionViewType([UIView])
    case calendarCollectionViewType
    case recipeCellType(UIImage, String)
    case recipeSearchCellType(UIImage, String, Bool)
}

extension MPTableViewCellType {
    func configureCell()-> MPTableViewCellProtocol {
        switch (self) {
        case .horizontalCollectionViewType(let Array): return HorizontalCollectionViewItem(viewArray: Array)
        case .calendarCollectionViewType: return CalendarViewItem()
        case .recipeCellType(let image, let title):
            return RecipeCellItem(image: image, title: title)
        case .recipeSearchCellType(let image, let title, let selected):
            return RecipeSearchCellItem(image: image, title: title, selected: selected)
        }
    }
}

protocol MPTableViewCellProtocol {
    //var cell: UITableViewCell {get}
    var reuseIdentifier: String {get}
    var rowHeight: Int {get}
}

enum horizontalCollectionViewItemType {
    case imageType
    case chartType
}

struct HorizontalCollectionViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "HorizontalCollectionView"
    var rowHeight: Int = 70
    var viewArray: [UIView] = []
    
    init(viewArray: [UIView] = []) {
        self.viewArray = viewArray
    }
}


struct CalendarViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "CalendarCollectionView"
    var rowHeight: Int = 246
}

struct RecipeCellItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeTableViewCell"
    var rowHeight: Int = 80
    var image: UIImage?
    var title: String = ""
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}

struct RecipeSearchCellItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeSearchResultCell"
    var rowHeight: Int = 80
    var image: UIImage?
    var title: String = ""
    var selected: Bool = false
    
    init(image: UIImage, title: String, selected: Bool) {
        self.image = image
        self.title = title
        self.selected = selected
    }
}

//protocol MPTableViewControllerDelegateProtocol: class {
//    func MPCalendarCellDidSelect()
//}

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var rowArray: [MPTableViewCellType] = []
    //weak var delegate: MPTableViewControllerDelegateProtocol?
}

extension MPTableViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.configureCell().reuseIdentifier, for: indexPath)
        switch (item) {
        case .horizontalCollectionViewType:
            let cell = cell as! HorizontalCollectionView
            guard let itemStruct = item.configureCell() as? HorizontalCollectionViewItem else {return cell}
            cell.viewArray = itemStruct.viewArray
            //cell.frame = tableView.bounds
            //cell.layoutIfNeeded()
            return cell
        case .calendarCollectionViewType:
            let cell = cell as! CalendarCollectionView
            //cell.frame = tableView.bounds
            //cell.layoutIfNeeded()
            //cell.delegate = self
            return cell
        case .recipeCellType:
            let cell = cell as! RecipeTableViewCell
            guard let itemStruct = item.configureCell() as? RecipeCellItem else {return cell}
            cell.recipeImage.image = itemStruct.image
            cell.recipeName.text = itemStruct.title
            cell.backgroundColor = UIColor.clear
            return cell
        case .recipeSearchCellType:
            let cell = cell as! RecipeSearchResultCell
            guard let itemStruct = item.configureCell() as? RecipeSearchCellItem else {return cell}
            cell.recipeImage.image = itemStruct.image
            cell.recipeTitle.text = itemStruct.title
            cell.selectRecipe.addTarget(self, action: #selector(selectRecipeAction(_:)), for: .touchUpInside)
            cell.selectRecipe.tag = indexPath.row
            if itemStruct.selected {
                cell.selectRecipe.setImage(#imageLiteral(resourceName: "success_green"), for: .normal)
            } else {
                cell.selectRecipe.setImage(#imageLiteral(resourceName: "success_black"), for: .normal)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowArray[indexPath.row].configureCell().rowHeight)
    }
    

}

//extension MPTableViewController: MPCalendarViewDelegateProtocol {
//    
//    func calendarDidSelect(date: Date) {
//        self.delegate?.MPCalendarCellDidSelect()
//    }
//}

extension MPTableViewController {
    @objc func selectRecipeAction(_ sender : UIButton) {
        
    }
}

