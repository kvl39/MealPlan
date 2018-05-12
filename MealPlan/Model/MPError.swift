//
//  MPError.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

enum MPError: Error {
    case BadURL
    case JSONNotDecodable
    case RequestFail
}
