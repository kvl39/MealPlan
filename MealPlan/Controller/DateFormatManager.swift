//
//  DateFormatManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/10.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

class DataFormatManager {
    
    let formatter = DateFormatter()
    
    func stringToDate(dateString: String, to format: String)-> Date? {
        formatter.dateFormat = format
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter.date(from: dateString) 
    }
    
    
    func extractDayFromDate(dateString: String)-> String? {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let tempDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd"
        guard let tempDate1 = tempDate else {return nil}
        let A = formatter.string(from: tempDate1)
        return A
    }
    
}
