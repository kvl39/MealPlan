//
//  DateFormatManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/10.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation


struct BeginEndOfWeek {
    var beingDate: DateComponents
    var endDate: DateComponents
}

class DataFormatManager {

    let formatter = DateFormatter()
    var calendar = Calendar(identifier: .gregorian)

    func stringToDate(dateString: String, to format: String) -> Date? {
        formatter.dateFormat = format
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter.date(from: dateString)
    }

    func extractDayFromDate(dateString: String) -> String? {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let tempDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd"
        guard let tempDate1 = tempDate else {return nil}
        return formatter.string(from: tempDate1)
    }
    
    
    //get Weekday for a given year, month, day
    func extractWeekdayFromDate(dateString: String)-> Int? {
        //create dateComponent by year, month, day
        //create date from dateComponent
        //create dateComponent from date and check the weekDay property of the dateComponent
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let date = formatter.date(from: dateString) else {return nil}
        let dateInDateComponentsFormat = calendar.dateComponents([.year, .month, .day], from: date)
        return dateInDateComponentsFormat.weekday
    }
    
    
    func extractBeginEndDateFromYearMonth(year: Int, month: Int)-> [BeginEndOfWeek]? {
        var beginEndOfWeekArray = [BeginEndOfWeek]()
        
        //get number of weeks in a month
        guard let numberOfWeeks = numberOfMondaysInMonth(month, forYear: year) else {return nil}
        //get begin/end day of each week
        for index in 0..<numberOfWeeks {
            let beginDateComponents = getBeginOrEndOfAWeek(year: year, month: month, indexOfWeekInAMonth: index, isGettingBegin: true)
            let endDateComponents = getBeginOrEndOfAWeek(year: year, month: month, indexOfWeekInAMonth: index, isGettingBegin: false)
            guard let begin = beginDateComponents,
                let end = endDateComponents else {return nil}
            let beginEndOfAWeek = BeginEndOfWeek(beingDate: begin, endDate: end)
            beginEndOfWeekArray.append(beginEndOfAWeek)
        }
        return beginEndOfWeekArray
    }
    
    func getBeginOrEndOfAWeek(year: Int, month: Int, indexOfWeekInAMonth: Int, isGettingBegin: Bool)-> DateComponents?{
        var dateComps = DateComponents()
        dateComps.year = year
        dateComps.month = month
        dateComps.weekday = (isGettingBegin ? 2: 1)
        //Monday is the beginning of a week
        //Sunday is the end of a week
        dateComps.weekdayOrdinal = indexOfWeekInAMonth + 1
        let dateInDateFormat = calendar.date(from: dateComps)
        if let firstDate = dateInDateFormat {
            let day = calendar.dateComponents([.year, .month, .day], from: firstDate)
            return day
        } else {
            return nil
        }
    }
    
    
    func numberOfMondaysInMonth(_ month: Int, forYear year: Int) -> Int? {
        calendar.firstWeekday = 2 // 2 == Monday
        
        // First monday in month:
        var comps = DateComponents(year: year, month: month,
                                   weekday: calendar.firstWeekday, weekdayOrdinal: 1)
        guard let first = calendar.date(from: comps)  else {
            return nil
        }
        
        // Last monday in month:
        comps.weekdayOrdinal = -1
        guard let last = calendar.date(from: comps)  else {
            return nil
        }
        
        // Difference in weeks:
        let weeks = calendar.dateComponents([.weekOfMonth], from: first, to: last)
        return weeks.weekOfMonth! + 1
    }
    

}
