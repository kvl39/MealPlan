//
//  RecipeCalendarModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/9.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import RealmSwift


class RecipeCalendarRealmModel: Object {
    @objc dynamic var recipeDay = Date(timeIntervalSince1970: 1)
    //let RecipeRealmModel = List<RecipeRealmModel>()
    @objc dynamic var recipeRealmModel: RecipeRealmModel? = nil
}

class RecipeRealmModel: Object {
    @objc dynamic var url = ""
    @objc dynamic var label = ""
    @objc dynamic var image = ""
    let ingredients = List<IngredientRecipeModel>()
    let nutrients = List<Nutrients>()
}

class IngredientRecipeModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var weight = 0.0
}

class Nutrients: Object {
    @objc dynamic var label = ""
    @objc dynamic var quantity = 0.0
}


