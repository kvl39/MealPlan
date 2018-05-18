//
//  MPFirebaseModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/18.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

struct MPFirebaseRecipeModel {
    var calories: Double
    var image: String
    var label: String
    var url: String
    var ingredients: [MPFirebaseRecipeIngredientModel]
    var nuitrients: [MPFirebaseRecipeNuitrientModel]
}

struct MPFirebaseRecipeIngredientModel {
    var name: String
    var weight: Double
}

struct MPFirebaseRecipeNuitrientModel {
    var label: String
    var quantity: Double
}

//struct RecipeModel: Codable {
//
//    var more: Bool
//    var count: Int
//    var hits: [hits]
//
//}
//
//struct hits: Codable {
//    var recipe: RecipeInformation
//}
//
//struct RecipeInformation: Codable {
//    var url: URL
//    var image: URL
//    var label: String
//    var ingredients: [IngredientAPIModel]
//    var calories: Double
//    var totalDaily: TotalDaily
//}
