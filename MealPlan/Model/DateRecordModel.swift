//
//  DateRecordModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit


enum DateRecordType {
    case month
    case week
    case day
}

struct DateRecord {
    var dateRecordType: DateRecordType
    var year: Int
    var month: Int
    var day: Int?
    var startDate: DateComponents?
    var endDate: DateComponents?
    var imageViewArray: [UIImageView]?
    var recipeData: [RecipeCalendarRealmModel]?
}
