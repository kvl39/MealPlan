//
//  RecipeClassModel.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/6.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeClass {
    var recipeTitle: [String] {get}
    var recipeImage: [UIImage] {get}
    var childArray: [RecipeClass] {get}
    var recipeTitleEnglish: [String] {get}
}

extension RecipeClass {
    var childArray: [RecipeClass] {
        return []
    }
    var recipeTitleEnglish: [String] {
        return []
    }
}

struct RecipeClassLayer0: RecipeClass {
    var recipeTitle: [String] = ["肉類", "蔬菜", "國家"]
    var childArray: [RecipeClass] = [RecipeClassLayer1_Meat(), RecipeClassLayer1_Veg(), RecipeClassLayer1_Country()]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "meat"), #imageLiteral(resourceName: "vegetable"), #imageLiteral(resourceName: "world")]
}

struct RecipeClassLayer1_Meat: RecipeClass {
    var recipeTitle: [String] = ["豬肉", "牛肉"]
    var recipeTitleEnglish: [String] = ["pork", "beef"]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "pig"), #imageLiteral(resourceName: "cow")]
}

struct RecipeClassLayer1_Veg: RecipeClass {
    var recipeTitle: [String] = ["高麗菜", "菠菜"]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "cabbage"), #imageLiteral(resourceName: "spinach")]
    var recipeTitleEnglish: [String] = ["Cabbage", "spinach"]
}

struct RecipeClassLayer1_Country: RecipeClass {
    var recipeTitle: [String] = ["中式", "西式"]
    var childArray: [RecipeClass]
        = [RecipeClassLayer2_Chinese(), RecipeClassLayer2_Western()]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "success_green"), #imageLiteral(resourceName: "btn_like_normal")]
}

struct RecipeClassLayer2_Chinese: RecipeClass {
    var recipeTitle: [String] = ["中國", "台灣", "泰國", "越南"]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "success_green"), #imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "success_green"), #imageLiteral(resourceName: "btn_like_normal")]
}

struct RecipeClassLayer2_Western: RecipeClass {
    var recipeTitle: [String] = ["美國", "西班牙", "英國", "法國"]
    var recipeImage: [UIImage] = [#imageLiteral(resourceName: "success_green"), #imageLiteral(resourceName: "btn_like_normal"), #imageLiteral(resourceName: "success_green"), #imageLiteral(resourceName: "btn_like_normal")]
}

protocol RecipeClassification {
    var className: String {get}
    var imageArray: [UIImage] {get}
    var titleArray: [String] {get}
    var englishTitleArray: [String] {get}
}



struct RecipeClassifications {
    var recipeClassificationsArray = [RecipeClassification]()
}

struct RecipeClassificationMeat: RecipeClassification {
    var className: String = "肉類"
    var imageArray: [UIImage] = [#imageLiteral(resourceName: "pig"),#imageLiteral(resourceName: "cow"),#imageLiteral(resourceName: "chicken"), #imageLiteral(resourceName: "fish"), #imageLiteral(resourceName: "goat"), #imageLiteral(resourceName: "turkey"), #imageLiteral(resourceName: "shrimp")]
    var titleArray: [String] = ["豬肉","牛肉", "雞肉", "魚肉", "羊肉", "火雞", "蝦"]
    var englishTitleArray: [String] = ["pork", "beef", "chicken", "fish", "lamb", "turkey", "shrimp"]
}

struct RecipeClassificationVegatable: RecipeClassification {
    var className: String = "蔬菜"
    var imageArray: [UIImage] = [#imageLiteral(resourceName: "cabbage"), #imageLiteral(resourceName: "vegetable"), #imageLiteral(resourceName: "broccoli"), #imageLiteral(resourceName: "brussels-sprouts"), #imageLiteral(resourceName: "beans"), #imageLiteral(resourceName: "celery"), #imageLiteral(resourceName: "potato"), #imageLiteral(resourceName: "radish"), #imageLiteral(resourceName: "carrot")]
    var titleArray: [String] = ["高麗菜", "菠菜", "花椰菜", "甘藍", "豆子", "芹菜", "馬鈴薯", "白蘿蔔", "紅蘿蔔"]
    var englishTitleArray: [String] = ["cabbage", "spinach", "broccoli", "brussel sprout", "beans", "celery", "potato", "trunip", "carrot"]
}
