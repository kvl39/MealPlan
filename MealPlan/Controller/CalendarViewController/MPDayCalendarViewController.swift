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
    var numberOfWeekAddedAtTheBeginning = 0
    var dateRecord = [DateRecord]()
    var realmManager = RealmManager()
    var saveImageManager = SaveImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        dayCalendarView.delegate = self
        dayCalendarView.dataSource = self
        dayCalendarView.register(UINib(nibName: "MonthTableViewCell", bundle: nil), forCellReuseIdentifier: "MonthTableViewCell")
        dayCalendarView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
        dayCalendarView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayTableViewCell")
        
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
        dayCalendarView.contentOffset.y = (CGFloat(4) * CGFloat(50) + CGFloat(100))
        
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
            
            let dateRecordCell = DateRecord(dateRecordType: .month, year: thisYear, month: thisMonth, day: nil, startDate: nil, endDate: nil, imageViewArray: nil, recipeData: nil)
            
            if isAtTheBeginning {
                rowArray[0].insert(.monthType("\(thisYear) \(thisMonth)"), at: 0)
                self.beginningDate = date
                self.dateRecord.insert(dateRecordCell, at: 0)
            } else {
                rowArray[0].append(.monthType("\(thisYear) \(thisMonth)"))
                self.endDate = date
                self.dateRecord.append(dateRecordCell)
            }
        }
    }
    
    func generateWeekRowForWeekCell(in year: Int, month: Int, isAtTheBeginning: Bool) {
        var index = 1
        numberOfWeekAddedAtTheBeginning = 0
        if let beginEndArrayThisMonth = dateManager.extractBeginEndDateFromYearMonth(year: year, month: month) {
            for beginEndDay in beginEndArrayThisMonth {
                if let monthOfBeginDate = beginEndDay.beingDate.month,
                    let dayOfBeginDate = beginEndDay.beingDate.day,
                    let monthOfEndDate = beginEndDay.endDate.month,
                    let dayOfEndDate = beginEndDay.endDate.day {
                    
                    
                    let dateRecordCell = DateRecord(dateRecordType: .week, year: year, month: month, day: nil, startDate: beginEndDay.beingDate, endDate: beginEndDay.endDate, imageViewArray: nil, recipeData: nil)
                    
                    
                    if isAtTheBeginning {
                        rowArray[0].insert(.weekType("\(monthOfBeginDate)/\(dayOfBeginDate)~\(monthOfEndDate)/\(dayOfEndDate)"), at: index)
                        numberOfWeekAddedAtTheBeginning += 1
                        //self.dateRecord.insert(dateRecordCell, at: index)
                    } else {
                        rowArray[0].append(.weekType("\(monthOfBeginDate)/\(dayOfBeginDate)~\(monthOfEndDate)/\(dayOfEndDate)"))
                        //self.dateRecord.append(dateRecordCell)
                    }
                    if let newIndex = fetchData(beginEndDay: beginEndDay, isAtTheBeginning: isAtTheBeginning, indexToInsert: index) {
                        index = newIndex
                    }
                }
                index += 1
            }
        }
    }
    
    
    func fetchData(beginEndDay: BeginEndOfWeek, isAtTheBeginning: Bool, indexToInsert: Int)-> Int? {
        var indexOfRow = indexToInsert
        guard let numberOfDayInBetween = dateManager.getDateComponentsInBetween(beginEndOfWeek: beginEndDay) else {return nil}
        let beginDateComponent = beginEndDay.beingDate
        guard let beginDate =
            dateManager.dateComponentToDate(dateComponent: beginDateComponent) else {return nil}
        var dateInBetween = beginDate
        for index in 0..<numberOfDayInBetween {
            if let nextDate = dateManager.getNextDay(date: dateInBetween) {
                dateInBetween = nextDate
                self.fetchDataInDate(in: nextDate) { (recipeArray, imageView) in
                    if recipeArray.count > 0 {
                        let nextDateComponent = dateManager.dateToDateComponent(date: nextDate)
                        if let day = nextDateComponent.day,
                            let weekDay = nextDateComponent.weekday {
                            if isAtTheBeginning {
                                indexOfRow += 1
                                self.rowArray[0].insert(.dayType(String(day), String(weekDay), imageView), at: indexOfRow)
                                //add data to record
                            } else {
                                self.rowArray[0].append(.dayType(String(day), String(weekDay), imageView))
                                //add data to record
                            }
                        }
                    }
                }
            }
        }
        return indexOfRow
        //get all date in between
        //fetch all recipe data in between
        //add rows from those data
        
    }
    
    func fetchDataInDate(in date: Date,
                         completion: ([RecipeCalendarRealmModel],[UIImageView])-> Void) {
        let result = self.realmManager.fetchRecipe(in: date)
        
        guard let fetchResult = result else {return}
        //self.recipeToday = fetchResult
        var imageViewArray = [UIImageView]()
        for recipe in fetchResult {
            if recipe.withSteps == false {
                guard let recipeLabel = recipe.recipeRealmModel?.label,
                    let recipeImageURL = recipe.recipeRealmModel?.image else {return}
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
                imageView.contentMode = .scaleAspectFill
                imageView.sd_setImage(with: URL(string: recipeImageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (_, error, _, _) in
                    guard let error = error else {return}
                    print(error)
                }
                
                imageViewArray.append(imageView)
                //self.recipeTitleArray.append(recipeLabel)
                //self.recipeImageArray.append(imageView)
                
            } else {
                guard let recipeLabel = recipe.recipeRealmModelWithSteps?.label,
                    let recipeImageName = recipe.recipeRealmModelWithSteps?.image else {return}
                let recipeImage = self.saveImageManager.getSavedImage(imageFileName: recipeImageName)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
                imageView.image = recipeImage
                imageView.contentMode = .scaleAspectFill
                imageViewArray.append(imageView)
                //self.recipeTitleArray.append(recipeLabel)
                //self.recipeImageArray.append(imageView)
            }
            
        }
        
        completion(fetchResult, imageViewArray)
        
    }

}


extension MPDayCalendarViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("content offset y:\(scrollView.contentOffset.y)")
        let top: CGFloat = 0.0
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = 300.0
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition > bottom - buffer {
            guard let nextMonth = dateManager.getNextMonth(date: self.endDate) else {return}
            generateRowsForOneMonth(in: nextMonth, isAtTheBeginning: false)
            dayCalendarView.reloadData()
        } else if scrollPosition < top + buffer {
            // Add more dates to the top
            guard let previousMonth = dateManager.getPreviousMonth(date: self.beginningDate) else {return}
            print("previousMonth:\(previousMonth)")
            generateRowsForOneMonth(in: previousMonth, isAtTheBeginning: true)
    
            // Update the tableView and contentOffset
            dayCalendarView.reloadData()
            dayCalendarView.contentOffset.y +=  (CGFloat(self.numberOfWeekAddedAtTheBeginning) * CGFloat(50) + CGFloat(100))
        }

    }
}
