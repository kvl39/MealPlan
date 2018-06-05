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
    var selectedCollectViewImageView = UIImageView()
    var selectedRow = 0
    var recipeToday: [RecipeCalendarRealmModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureObserver()
    }
    
    
    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectCollectionViewItem(notification:)), name: NSNotification.Name(rawValue: "collectionViewItemDidSelect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newRecipeAdded(notification:)), name: NSNotification.Name(rawValue: "searchViewAddRecipe"), object: nil)
        
    }
    
    @objc func newRecipeAdded(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let recipeData = userInfo["recipeData"] as? [RecipeCalendarRealmModel],
            let date = userInfo["date"] as? Date else {return}
        initSetting()
        //findInsertRow(date: date, recipeData: recipeData)
    }
    
    func initSetting() {
        self.dateRecord = []
        self.rowArray[0] = []
        let date = Date()
        guard let nextMonth = dateManager.getNextMonth(date: date),
            let previousMonth = dateManager.getPreviousMonth(date: date) else {return}
        
        
        generateRowsForOneMonth(in: date, isAtTheBeginning: false)
        generateRowsForOneMonth(in: nextMonth, isAtTheBeginning: false)
        generateRowsForOneMonth(in: previousMonth, isAtTheBeginning: true)
        dayCalendarView.contentOffset.y = (CGFloat(4) * CGFloat(50) + CGFloat(100))
        self.dayCalendarView.reloadData()
    }
    
    
    @objc func onSelectCollectionViewItem(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let imageView = userInfo["imageView"] as? UIImageView,
            let selectedRow = userInfo["row"] as? Int,
            let today = userInfo["today"] as? Date else {return}
        self.selectedCollectViewImageView = imageView
        self.selectedRow = selectedRow
        let result = self.realmManager.fetchRecipe(in: today)
        guard let fetchResult = result else {return}
        self.recipeToday = fetchResult
//        print("selected:\(self.selectedRow)")
        self.performSegue(withIdentifier: "PushToDetailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PushToDetailPage") {
            guard let vc = segue.destination as? MPRecipeDetailViewController else {return}
            vc.displayImage = self.selectedCollectViewImageView.image
            vc.recipeData = self.recipeToday[self.selectedRow]
            vc.isSegueFromCalendarView = true
        }
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
        
    }
    
    
    
    func findInsertRow(date: Date, recipeData: [RecipeCalendarRealmModel]) {
        //this function is triggered when user creates a new recipe, add recipe from search view or from discovery view
        
        var imageViewArray = [UIImageView]()
        for recipe in recipeData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
            imageView.contentMode = .scaleAspectFill
            
            if recipe.withSteps == false {
                guard let imageURL = recipe.recipeRealmModel?.image else {return}
                
                imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (_, error, _, _) in
                    guard let error = error else {return}
                    print(error)
                }
                imageViewArray.append(imageView)
            } else {
                guard let imageURL = recipe.recipeRealmModelWithSteps?.image else {return}
                
                imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (_, error, _, _) in
                    guard let error = error else {return}
                    print(error)
                }
                imageViewArray.append(imageView)
            }
            
        }
        
        //find the specific row by year, month, day
  
            //find cells in between these two week cell and check if the specific row exists or not
        var targetRowIndex = 0
        var nextTargetRowIndex = 0
        var didFindTargetRow = false
        var didFindNextTargetRow = false
        for index in 0..<dateRecord.count {
            //ignore month cell
            if dateRecord[index].dateRecordType == .week {
                //find week cell which the specific date is in between
                if let startDateComponents = dateRecord[index].startDate,
                    let endDateComponents = dateRecord[index].endDate,
                    let startDate = dateManager.dateComponentToDate(dateComponent: startDateComponents),
                    let endDate = dateManager.dateComponentToDate(dateComponent: endDateComponents) {
                    
                    if ((date > startDate) && (date < endDate)) {
                        targetRowIndex = index
                        didFindTargetRow = true
                        //find next week cell's row number
                        for index1 in targetRowIndex+1..<dateRecord.count {
                            if dateRecord[index1].dateRecordType == .week {
                                nextTargetRowIndex = index1
                                didFindNextTargetRow = true
                                break
                            }
                        }
                        break
                    }
                }
            }
        }
        
        
        
        if didFindTargetRow && didFindNextTargetRow {
            
            var sameDayExist = false
            let todayDateComponents = self.dateManager.dateToDateComponent(date: date)
            for index in targetRowIndex..<nextTargetRowIndex {
                if let rowDate = self.dateRecord[index].day,
                    let addDay = todayDateComponents.day {
                    if ((self.dateRecord[index].year == todayDateComponents.year) &&
                        (self.dateRecord[index].month == todayDateComponents.month) &&
                        (rowDate == addDay)) {
                        sameDayExist = true
                        //if the specific row exists, retrieve the image array from record, then add a new row
                        self.dateRecord[index].imageViewArray! += imageViewArray
                        guard let day = todayDateComponents.day,
                            let weekday = todayDateComponents.weekday else {return}
                        self.rowArray[0][index] = .dayType(String(day), String(weekday), imageViewArray, date)
                        reloadRow(at: index)
                        break
                    }
                }
                
            }
            if sameDayExist == false {
                //if the specific row doesn't exist, create a new row withe image view
                
                guard let year = todayDateComponents.year,
                    let month = todayDateComponents.month,
                    let day = todayDateComponents.day ,
                    let weekday = todayDateComponents.weekday else {return}
                let dateRecordCell = DateRecord(dateRecordType: .day, year: year, month: month, day: day, startDate: nil, endDate: nil, imageViewArray: imageViewArray, recipeData: nil)
                self.dateRecord.insert(dateRecordCell, at: targetRowIndex)
                self.rowArray[0].insert(.dayType(String(day), String(weekday), imageViewArray, date), at: targetRowIndex)
                reloadRow(at: targetRowIndex+1)
            }
            
        }
        
        
        
        
    }
    
    
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.dayCalendarView.cellForRow(at: indexPath) as? DayTableViewCell else {return}
        cell.horizontalCollectionView.reloadData()
        self.dayCalendarView.reloadData()
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
            
            let thisMonthName = dateManager.monthTranlation(month: thisMonth)
            
            if isAtTheBeginning {
                rowArray[0].insert(.monthType("\(thisYear) \(thisMonthName)"), at: 0)
                self.beginningDate = date
                self.dateRecord.insert(dateRecordCell, at: 0)
            } else {
                rowArray[0].append(.monthType("\(thisYear) \(thisMonthName)"))
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
                        self.dateRecord.insert(dateRecordCell, at: index)
                    } else {
                        rowArray[0].append(.weekType("\(monthOfBeginDate)/\(dayOfBeginDate)~\(monthOfEndDate)/\(dayOfEndDate)"))
                        self.dateRecord.append(dateRecordCell)
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
                            let weekDay = nextDateComponent.weekday,
                            let year = nextDateComponent.year,
                            let month = nextDateComponent.month{
                            
                            let dateRecordCell = DateRecord(dateRecordType: .day, year: year, month: month, day: day, startDate: nil, endDate: nil, imageViewArray: imageView, recipeData: recipeArray)
                            
                            let weekDayName = dateManager.weekdayTranslation(weekday: weekDay)
                            if isAtTheBeginning {
                                indexOfRow += 1
                                self.rowArray[0].insert(.dayType(String(day), weekDayName, imageView, nextDate), at: indexOfRow)
                                self.dateRecord.insert(dateRecordCell, at: indexOfRow)
                            } else {
                                self.rowArray[0].append(.dayType(String(day), weekDayName, imageView, nextDate))
                                self.dateRecord.append(dateRecordCell)
                            }
                        }
                    }
                }
            }
        }
        return indexOfRow
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


extension MPDayCalendarViewController: ZoomingViewController {
    
    func zoomingImageView() -> UIImageView? {
        return self.selectedCollectViewImageView
    }
}
