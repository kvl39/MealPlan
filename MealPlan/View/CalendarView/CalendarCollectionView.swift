//
//  CalendarView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCollectionView: MPCalendarView {
    
    
    @IBOutlet weak var calendarCollectionView: JTAppleCalendarView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        calendarCollectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCalendarView() {
        calendarCollectionView.minimumLineSpacing = 0
        calendarCollectionView.minimumInteritemSpacing = 0
        
        //setup labels at the first run
        calendarCollectionView.visibleDates { (visibleDates) in
            self.configureLabel(visibleDates: visibleDates)
        }
    }
    
    func configureLabel(visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        //        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        //        monthLabel.text = formatter.string(from: date)
        
    }
    
}

