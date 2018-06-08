//
//  DayTableViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DayTableViewCell: MPCollectionViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var viewForHorizontalCollectionView: UIView!
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    
    var today: Date = Date()
    var dateManager = DataFormatManager()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        self.horizontalCollectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")
        self.itemCount = self.viewArray.count
        horizontalCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        //guard let imageView = self.viewArray[indexPath.row].viewWithTag(2) as? UIImageView else {return}
        guard let imageView = self.viewArray[indexPath.row] as? UIImageView else {return}
        //let todayDateString = dateManager.dateToString(date: self.today)
        NotificationCenter.default.post(name: Notification.Name("collectionViewItemDidSelect"), object: nil, userInfo: ["imageView": imageView, "row": indexPath.row, "today": today])
    }
    
    
    
}
