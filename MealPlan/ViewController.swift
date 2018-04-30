//
//  ViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/4/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //setup labels at the first run
        calendarView.visibleDates { (visibleDates) in
            self.configureLabel(visibleDates: visibleDates)
        }
    }
    
    func configureLabel(visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        monthLabel.text = formatter.string(from: date)
        
    }

}


extension ViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")! //don't do this in real app
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameter
        
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! CustomCell
        configureCell(cell: cell, cellState: cellState)
        configureTextColor(cell: cell, cellState: cellState)
        
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        configureCell(cell: cell, cellState: cellState)
        configureTextColor(cell: cell, cellState: cellState)
        return cell
        
    }
    
    
    
    func configureCell(cell: CustomCell, cellState: CellState) {
        cell.dateLabel.text = cellState.text
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    
    
    func configureTextColor(cell: CustomCell, cellState: CellState) {
  
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLabel.textColor = UIColor.white
            } else {
                cell.dateLabel.textColor = UIColor.gray
            }
        }
       
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCell else {return}
        validCell.selectedView.isHidden = false
        configureTextColor(cell: validCell, cellState: cellState)
        
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCell else {return}
        validCell.selectedView.isHidden = true
        configureTextColor(cell: validCell, cellState: cellState)
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        configureLabel(visibleDates: visibleDates)
        
    }
    
}
