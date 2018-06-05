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
    
    func saveLikedMenu(menuRecipes: [MPFirebaseRecipeModel]) {
        saveQueue.async {
            let realm = try! Realm()
            
            let menu = likedMenuRealmModel()
            var counter = 0
            for recipe in menuRecipes {
                let recipeRealmType = self.recipeFormatTransition(from: recipe)
                menu.recipes.append(recipeRealmType)
                counter += 1
            }
            try! realm.write {
                realm.add(menu)
            }
        }
    }
    
    
    func recipeFormatTransition(from recipe: MPFirebaseRecipeModel) -> RecipeRealmModel {
        let recipeRealmType = RecipeRealmModel()
        recipeRealmType.calories = recipe.calories
        recipeRealmType.image = recipe.image
        recipeRealmType.label = recipe.label
        recipeRealmType.url = recipe.url
        for ingredient in recipe.ingredients {
            let recipeIngredientRealmType = IngredientRecipeModel()
            recipeIngredientRealmType.name = ingredient.name
            recipeIngredientRealmType.weight = ingredient.weight
            recipeRealmType.ingredients.append(recipeIngredientRealmType)
        }
        for nuitrient in recipe.nuitrients {
            let recipeNuitrientRealmType = Nutrients()
            recipeNuitrientRealmType.label = nuitrient.label
            recipeNuitrientRealmType.quantity = nuitrient.quantity
            recipeRealmType.nutrients.append(recipeNuitrientRealmType)
        }
        return recipeRealmType
    }
    
    func recipeFormatTransition(from recipe: MPFirebaseRecipeModel, in recipeDate: String) -> RecipeCalendarRealmModel? {
        let recipeRealmType = self.recipeFormatTransition(from: recipe)
        let recipeRealmCalendarType = RecipeCalendarRealmModel()
        guard let addDate = self.dateManager.stringToDate(dateString: recipeDate, to: "yyyy MM dd") else {return nil}
        recipeRealmCalendarType.recipeDay = addDate
        recipeRealmCalendarType.withSteps = false
        recipeRealmCalendarType.recipeRealmModel = recipeRealmType
        return recipeRealmCalendarType
    }
    
    
    func saveUserCreatedRecipe(createdRecipe: RecipeCalendarRealmModel) {
        saveQueue.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(createdRecipe)
            }
        }
    }
    
    func saveAddedRecipeInCalendarFormat(recipeArray: [RecipeCalendarRealmModel]) {
        let realm = try! Realm()
        for recipe in recipeArray {
            try! realm.write {
                realm.add(recipe)
            }
        }
    }
    
    func updateRecipe(recipeArray: [RecipeCalendarRealmModel], dateString: String) {
        let realm = try! Realm()
        let dataInRealm = fetchRecipe(in: dateString)
        if let data = dataInRealm {
            for index in 0..<recipeArray.count {
                if index < data.count {
                    try! realm.write {
                        data[index].recipeRealmModel = recipeArray[index].recipeRealmModel
                    }
                } else {
                    try! realm.write {
                        realm.add(recipeArray[index])
                    }
                }
            }
        }
        
    }

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
                recipeRealmModel.calories = recipe.calories

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
    
    func removeAllData() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func fetchRecipe(in dateString: String) -> [RecipeCalendarRealmModel]? {

        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let date = formatter.date(from: dateString) else {return nil}

        return fetchRecipe(in: date)
    }
    
    func fetchRecipe(in date: Date)-> [RecipeCalendarRealmModel]?  {
        
        let realm = try! Realm()
        
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
    
    
    func removeReciep(in dateString: String) {
        let realm = try! Realm()
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let date = formatter.date(from: dateString) else {return}
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        let datePredicate = NSPredicate(format: "(%@ <= recipeDay) AND (recipeDay < %@)", argumentArray: [dateFrom, dateTo])
        
        let fetchResult = realm.objects(RecipeCalendarRealmModel.self).filter(datePredicate)
        
        
        try! realm.write {
            realm.delete(fetchResult)
        }
        
    }
    
    func recipeFormatTranslation(from recipe: RecipeInformation, in recipeDate: String)-> RecipeCalendarRealmModel? {
        
        let recipeModel = RecipeCalendarRealmModel()
        guard let addDate = self.dateManager.stringToDate(dateString: recipeDate, to: "yyyy MM dd") else {return nil}
        recipeModel.recipeDay = addDate
        
        let recipeRealmModel = RecipeRealmModel()
        
        recipeRealmModel.image = recipe.image.absoluteString
        recipeRealmModel.label = recipe.label
        recipeRealmModel.url = recipe.url.absoluteString
        recipeRealmModel.calories = recipe.calories
        
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
        
        return recipeModel
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}
