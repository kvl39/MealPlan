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
    let formatter = DateFormatter()
    var dateManager = DataFormatManager()
    
    func saveAddedRecipe(addedRecipe: [RecipeInformation], recipeDate: String) {
        saveQueue.async {
            let realm = try! Realm()
            
            for recipe in addedRecipe {
                let recipeModel = RecipeCalendarRealmModel()
                let currentdate = Date()
                //recipeModel.recipeDay = currentdate
                guard let addDate = self.dateManager.stringToDate(dateString: recipeDate, to: "yyyy MM dd") else {return}
                recipeModel.recipeDay = addDate
                
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
    

    func fetchRecipe(in dateString: String) -> [RecipeCalendarRealmModel]? {
        
        let realm = try! Realm()
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let date = formatter.date(from: dateString) else {return nil}
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        let datePredicate = NSPredicate(format: "(%@ <= recipeDay) AND (recipeDay < %@)", argumentArray: [dateFrom, dateTo])
        
        
        let fetchResult = realm.objects(RecipeCalendarRealmModel.self).filter(datePredicate).toArray(ofType: RecipeCalendarRealmModel.self)
        
        return fetchResult
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}
