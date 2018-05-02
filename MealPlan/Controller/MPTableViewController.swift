//
//  MPTableViewController.swift
//
//
//  Created by Liao Kevin on 2018/5/1.
//

import UIKit


enum MPTableViewCellType {
    case horizontalCollectionViewType(horizontalCollectionViewItemType, [UIView])
    case calendarCollectionViewType
}

extension MPTableViewCellType {
    func configureCell()-> MPTableViewCellProtocol {
        switch (self) {
        case .horizontalCollectionViewType(let type, let Array): return HorizontalCollectionViewItem(collectionViewItemType: type, viewArray: Array)
        case .calendarCollectionViewType: return CalendarViewItem()
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
    var collectionViewItemType: horizontalCollectionViewItemType = .imageType
    var viewArray: [UIView] = []
    
    init(collectionViewItemType: horizontalCollectionViewItemType = .imageType,
         viewArray: [UIView] = []) {
        self.collectionViewItemType = collectionViewItemType
        self.viewArray = viewArray
    }
}


struct CalendarViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "CalendarCollectionView"
    var rowHeight: Int = 246
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
            cell.type = itemStruct.collectionViewItemType
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

