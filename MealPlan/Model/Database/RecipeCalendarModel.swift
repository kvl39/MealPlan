//
//  RecipeCalendarModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/9.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import RealmSwift

class likedMenuRealmModel: Object {
    let recipes = List<RecipeRealmModel>()
}

class RecipeCalendarRealmModel: Object {
    @objc dynamic var recipeDay = Date(timeIntervalSince1970: 1)
    //let RecipeRealmModel = List<RecipeRealmModel>()
    @objc dynamic var recipeRealmModel: RecipeRealmModel?
    @objc dynamic var recipeRealmModelWithSteps: RecipeRealmModelWithSteps?
    @objc dynamic var withSteps = false
}

class RecipeRealmModelWithSteps: Object {
    @objc dynamic var label = ""
    @objc dynamic var image = ""
    @objc dynamic var calories = 0.0
    let ingredients = List<IngredientRecipeModel>()
    let nutrients = List<Nutrients>()
    let RecipeSteps = List<RecipeStep>()
}

class RecipeStep: Object {
    @objc dynamic var imageName = ""
    @objc dynamic var stepDescription = ""
}

class RecipeRealmModel: Object {
    @objc dynamic var url = ""
    @objc dynamic var label = ""
    @objc dynamic var image = ""
    @objc dynamic var calories = 0.0
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
