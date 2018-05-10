//
//  MPCalendarView.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol MPCalendarViewDelegateProtocol: class {
    func calendarDidSelect(date: Date)
}

class MPCalendarView: UITableViewCell, JTAppleCalendarViewDelegate {
    
    let formatter = DateFormatter()
    weak var delegate: MPCalendarViewDelegateProtocol?
    //static let notificationName = Notification.Name("myNotificationName")
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
        configureTextColor(cell: cell, cellState: cellState)
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
        configureTextColor(cell: cell, cellState: cellState)
        return cell
        
    }
    
    
    
    func configureCell(cell: CalendarCell, cellState: CellState) {
        cell.dateLabel.text = cellState.text
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    
    
    func configureTextColor(cell: CalendarCell, cellState: CellState) {
        
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.purple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLabel.textColor = UIColor.black
            } else {
                cell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = false
        configureTextColor(cell: validCell, cellState: cellState)
        self.delegate?.calendarDidSelect(date: date)
        formatter.dateFormat = "yyyy MM dd"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectDate"), object: nil, userInfo:["date": formatter.string(from: date)])
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CalendarCell else {return}
        validCell.selectedView.isHidden = true
        configureTextColor(cell: validCell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    }
}

extension MPCalendarView: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")! //don't do this in real app
        let endDate = formatter.date(from: "2020 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameter
    }
    
}


