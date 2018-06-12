//
//  DayTableViewCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol DayTableViewCellProtocol: class {
    func deleteItem(at row: Int, itemNumber: Int)
    func shareItem(date: Date)
}

class DayTableViewCell: MPCollectionViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var viewForHorizontalCollectionView: UIView!
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    var today: Date = Date()
    var dateManager = DataFormatManager()
    var row: Int = 0
    weak var delegate: DayTableViewCellProtocol?
    var realmManager = RealmManager()
    var firebaseManager = MPFirebaseManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        configureSharebutton()
    }
    
    func configureSharebutton() {
        shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        shareButton.tintColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
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
    
    override func deleteButtonDidPressed(sender: UIButton) {
        //sender.tag
        //self.row
        let indexPath = IndexPath(item: sender.tag, section: 0)
        //self.delegate?.deleteItem(at: self.row, itemNumber: sender.tag)
        self.viewArray.remove(at: indexPath.row)
        self.horizontalCollectionView.deleteItems(at: [indexPath])
    }
    
    
    @IBAction func shareButtonDidPressed(_ sender: UIButton) {
        //show action sheet
        self.delegate?.shareItem(date: today)
        
    }
    
    
    
}
