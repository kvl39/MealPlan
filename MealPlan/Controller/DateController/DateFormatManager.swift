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
    
    func dateToString(date: Date)-> String {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter.string(from: date)
    }
    
    func weekdayTranslation(weekday: Int)-> String {
        switch weekday {
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thu"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return "Sun"
        }
    }
    
    func monthTranlation(month: Int)-> String {
        switch month {
        case 1: return "Jan"
        case 2: return "Feb"
        case 3: return "Mar"
        case 4: return "Apr"
        case 5: return "May"
        case 6: return "Jun"
        case 7: return "Jul"
        case 8: return "Aug"
        case 9: return "Sep"
        case 10: return "Oct"
        case 11: return "Nov"
        case 12: return "Dec"
        default: return "Jan"
        }
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

    
    
    func dateToDateComponent(date: Date)-> DateComponents {
        return calendar.dateComponents([.year, .month, .day, .weekday], from: date)
    }
    
    func dateComponentToDate(dateComponent: DateComponents)-> Date? {
        return calendar.date(from: dateComponent)
    }
    
    func getNextMonth(date: Date)-> Date? {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) else {return nil}
        return nextMonth
    }
    
    
    func getPreviousMonth(date: Date)-> Date? {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: date) else {return nil}
        return previousMonth
    }
    
    func getNextDay(date: Date)-> Date? {
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: date) else {return nil}
        return nextDay
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
    
    func getDateComponentsInBetween(beginEndOfWeek: BeginEndOfWeek)-> Int? {
        let dateComponents = calendar.dateComponents([.day], from: beginEndOfWeek.beingDate, to: beginEndOfWeek.endDate)
        return dateComponents.day
    }
    
    func getBeginOrEndOfAWeek(year: Int, month: Int, indexOfWeekInAMonth: Int, isGettingBegin: Bool)-> DateComponents?{
        var dateComps = DateComponents()
        dateComps.year = year
        dateComps.month = month
        dateComps.weekday = (isGettingBegin ? 2: 1)
        //Monday is the beginning of a week
        //Sunday is the end of a week
        dateComps.weekdayOrdinal = isGettingBegin ?
            indexOfWeekInAMonth + 1: indexOfWeekInAMonth + 2//indexOfWeekInAMonth + 1
        let dateInDateFormat = calendar.date(from: dateComps)
        if let firstDate = dateInDateFormat {
            let day = calendar.dateComponents([.year, .month, .day], from: firstDate)
            print("day:\(day.day)")
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
