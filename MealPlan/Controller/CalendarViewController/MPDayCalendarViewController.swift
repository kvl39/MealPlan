//
//  MPDayCalendarViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPDayCalendarViewController: MPTableViewController {

    
    @IBOutlet weak var dayCalendarView: UITableView!
    var dateManager = DataFormatManager()
    var endDate: Date = Date()
    var beginningDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        dayCalendarView.delegate = self
        dayCalendarView.dataSource = self
        dayCalendarView.register(UINib(nibName: "MonthTableViewCell", bundle: nil), forCellReuseIdentifier: "MonthTableViewCell")
        dayCalendarView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
        
        //get today
        let date = Date()
        //get year, month, weekStart, weekEnd of the current week
        if (rowArray.count == 0) {
            rowArray.append([])
        }
        
        
        guard let nextMonth = dateManager.getNextMonth(date: date),
            let previousMonth = dateManager.getPreviousMonth(date: date) else {return}
        
        
        generateRowsForOneMonth(in: date, isAtTheBeginning: false)
        generateRowsForOneMonth(in: nextMonth, isAtTheBeginning: false)
        generateRowsForOneMonth(in: previousMonth, isAtTheBeginning: true)
        
        
        //get next month of current month
        //get previous month of current month
        //generate data for the three months
    }
    
    
    
    func generateRowsForOneMonth(in date: Date, isAtTheBeginning: Bool){
        generateRowForMonthCell(in: date, isAtTheBeginning: isAtTheBeginning)
        let dateInDateComponentFormat = dateManager.dateToDateComponent(date: date)
        if let thisYear = dateInDateComponentFormat.year,
            let thisMonth = dateInDateComponentFormat.month {
            generateWeekRowForWeekCell(in: thisYear, month: thisMonth, isAtTheBeginning: isAtTheBeginning)
        }
    }
    
    
    func generateRowForMonthCell(in date: Date, isAtTheBeginning: Bool) {
        let dateInDateComponentFormat = dateManager.dateToDateComponent(date: date)
        if let thisYear = dateInDateComponentFormat.year,
            let thisMonth = dateInDateComponentFormat.month {
            if isAtTheBeginning {
                rowArray[0].insert(.monthType("\(thisYear) \(thisMonth)"), at: 0)
                self.beginningDate = date
            } else {
                rowArray[0].append(.monthType("\(thisYear) \(thisMonth)"))
                self.endDate = date
            }
        }
    }
    
    func generateWeekRowForWeekCell(in year: Int, month: Int, isAtTheBeginning: Bool) {
        var index = 1
        if let beginEndArrayThisMonth = dateManager.extractBeginEndDateFromYearMonth(year: year, month: month) {
            for beginEndDay in beginEndArrayThisMonth {
                if let monthOfBeginDate = beginEndDay.beingDate.month,
                    let dayOfBeginDate = beginEndDay.beingDate.day,
                    let monthOfEndDate = beginEndDay.endDate.month,
                    let dayOfEndDate = beginEndDay.endDate.day {
                    if isAtTheBeginning {
                        rowArray[0].insert(.weekType("\(monthOfBeginDate)/\(dayOfBeginDate)~\(monthOfEndDate)/\(dayOfEndDate)"), at: index)
                    } else {
                        rowArray[0].append(.weekType("\(monthOfBeginDate)/\(dayOfBeginDate)~\(monthOfEndDate)/\(dayOfEndDate)"))
                    }
                }
                index += 1
            }
        }
    }

}


extension MPDayCalendarViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let top: CGFloat = 0
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = 300.0
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition > bottom - buffer {
            guard let nextMonth = dateManager.getNextMonth(date: self.endDate) else {return}
            generateRowsForOneMonth(in: nextMonth, isAtTheBeginning: false)
            dayCalendarView.reloadData()
        } 
//
//        // Reached the bottom of the list
//        if scrollPosition > bottom - buffer {
//            // Add more dates to the bottom
//            let lastDate = self.days.last!
//            let additionalDays = self.generateDays(
//                lastDate.dateFromDays(1),
//                endDate: lastDate.dateFromDays(self.daysToAdd)
//            )
//            self.days.append(contentsOf: additionalDays)
//
//            // Update the tableView
//            self.tableView.reloadData()
//        }
    }
}
