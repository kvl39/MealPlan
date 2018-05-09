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
    var ingredients: [IngredientAPIModel]
    var calories: Double
    var totalDaily: TotalDaily
}

struct IngredientAPIModel: Codable {
    var text: String
    var weight: Double
}

struct TotalDaily: Codable {
    var ENERC_KCAL: NutrientAPIModel
    var FAT: NutrientAPIModel
    var FASAT: NutrientAPIModel
}

struct NutrientAPIModel: Codable {
    var label: String
    var quantity: Double
}
