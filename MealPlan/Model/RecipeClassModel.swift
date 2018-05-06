//
//  RecipeClassModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/6.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation


protocol RecipeClass {
    var recipeTitle: [String] {get}
    //var recipeImageURL: [String] {get}
    var childArray: [RecipeClass] {get}
}

extension RecipeClass {
    var childArray: [RecipeClass] {
        return []
    }
}

struct RecipeClassLayer0: RecipeClass {
    var recipeTitle: [String] = ["肉類","蔬菜","國家"]
    var childArray: [RecipeClass] = [RecipeClassLayer1_Meat(), RecipeClassLayer1_Veg(), RecipeClassLayer1_Country()]
}

struct RecipeClassLayer1_Meat: RecipeClass {
    var recipeTitle: [String] = ["豬肉","牛肉"]
}

struct RecipeClassLayer1_Veg: RecipeClass {
    var recipeTitle: [String] = ["高麗菜","菠菜"]
}

struct RecipeClassLayer1_Country: RecipeClass {
    var recipeTitle: [String] = ["中式","西式"]
    var childArray: [RecipeClass]
        = [RecipeClassLayer2_Chinese(), RecipeClassLayer2_Western()]
}

struct RecipeClassLayer2_Chinese: RecipeClass {
    var recipeTitle: [String] = ["中國", "台灣", "泰國", "越南"]
}

struct RecipeClassLayer2_Western: RecipeClass {
    var recipeTitle: [String] = ["美國", "西班牙", "英國", "法國"]
}

