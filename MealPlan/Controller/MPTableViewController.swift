//
//  MPTableViewController.swift
//
//
//  Created by Liao Kevin on 2018/5/1.
//

import UIKit


enum MPTableViewCellType {
    case horizontalCollectionViewType
}

extension MPTableViewCellType {
    func configureCell()-> MPTableViewCellProtocol {
        switch (self) {
        case .horizontalCollectionViewType: return HorizontalCollectionViewItem()
        }
    }
}

protocol MPTableViewCellProtocol {
    //var cell: UITableViewCell {get}
    var reuseIdentifier: String {get}
    var rowHeight: Int {get}
}

struct HorizontalCollectionViewItem: MPTableViewCellProtocol {
    //var cell: UITableViewCell = CalendarCell()
    var reuseIdentifier: String = "HorizontalCollectionView"
    var rowHeight: Int = 70
}

struct CalendarView: MPTableViewCellProtocol {
    var reuseIdentifier: String = "CalendarCell"
    var rowHeight: Int = 263
}

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var rowArray: [MPTableViewCellType] = []
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
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowArray[indexPath.row].configureCell().rowHeight)
    }
    
}

