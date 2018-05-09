//
//  RealmManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/9.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    let saveQueue = DispatchQueue(label: "saveQueue")
    
    func saveAddedRecipe(addedRecipe: [RecipeInformation]) {
        saveQueue.async {
            let realm = try! Realm()
            
            for recipe in addedRecipe {
                let recipeModel = RecipeCalendarRealmModel()
                let currentdate = Date()
                recipeModel.recipeDay = currentdate
                
                let recipeRealmModel = RecipeRealmModel()
                
                
                recipeRealmModel.image = recipe.image.absoluteString
                recipeRealmModel.label = recipe.label
                recipeRealmModel.url = recipe.url.absoluteString
                
                
                for ingre in recipe.ingredients {
                    let ingredient = IngredientRecipeModel()
                    ingredient.name = ingre.text
                    ingredient.weight = ingre.weight
                    recipeRealmModel.ingredients.append(ingredient)
                }
                
                let nutri1 = Nutrients()
                nutri1.label = recipe.totalDaily.ENERC_KCAL.label
                nutri1.quantity = recipe.totalDaily.ENERC_KCAL.quantity
                recipeRealmModel.nutrients.append(nutri1)
                
                let nutri2 = Nutrients()
                nutri2.label = recipe.totalDaily.FASAT.label
                nutri2.quantity = recipe.totalDaily.FASAT.quantity
                recipeRealmModel.nutrients.append(nutri2)
                
                let nutri3 = Nutrients()
                nutri3.label = recipe.totalDaily.FAT.label
                nutri3.quantity = recipe.totalDaily.FAT.quantity
                recipeRealmModel.nutrients.append(nutri3)
                
                recipeModel.recipeRealmModel = recipeRealmModel
                
                try! realm.write {
                    realm.add(recipeModel)
                }
            }
            
            
        }
    }
}
