//
//  RecipeModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation


struct RecipeModel: Codable {
    
    var more: Bool
    var count: Int
    var hits: [hits]

}

struct hits: Codable {
    var recipe: RecipeInformation
}

struct RecipeInformation: Codable {
    var url: URL
    var image: URL
    var label: String
}
