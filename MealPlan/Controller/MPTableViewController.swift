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
    case recipeCellType(UIImage,String)
}

extension MPTableViewCellType {
    func configureCell()-> MPTableViewCellProtocol {
        switch (self) {
        case .horizontalCollectionViewType(let Array): return HorizontalCollectionViewItem(viewArray: Array)
        case .calendarCollectionViewType: return CalendarViewItem()
        case .recipeCellType(let image, let title):
            return RecipeCellItem(image: image, title: title)
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

protocol MPTableViewControllerDelegateProtocol: class {
    func MPCalendarCellDidSelect()
}

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var rowArray: [MPTableViewCellType] = []
    weak var delegate: MPTableViewControllerDelegateProtocol?
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowArray[indexPath.row].configureCell().rowHeight)
    }
    
}

extension MPTableViewController: MPCalendarViewDelegateProtocol {
    
    func calendarDidSelect(date: Date) {
        self.delegate?.MPCalendarCellDidSelect()
    }
    
}

