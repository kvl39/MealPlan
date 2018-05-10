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
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        calendarCollectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        setupCalendarView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCalendarView() {
        calendarCollectionView.minimumLineSpacing = 0
        calendarCollectionView.minimumInteritemSpacing = 0
        
        //setup labels at the first run
        calendarCollectionView.visibleDates { (visibleDates) in
            self.configureLabel(visibleDates: visibleDates)
        }
        
        //scroll to today
        calendarCollectionView.scrollToDate(Date(), animateScroll: false)
        calendarCollectionView.selectDates([ Date() ])
    }
    
    func configureLabel(visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        monthLabel.text = formatter.string(from: date)
    }
    

    override func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        super.calendar(calendar, didScrollToDateSegmentWith: visibleDates)
        configureLabel(visibleDates: visibleDates)
    }
    
    
    
}

