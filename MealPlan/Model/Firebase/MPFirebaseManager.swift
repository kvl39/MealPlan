//
//  FirebaseManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/17.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import Firebase




class MPFirebaseManager {
    lazy var ref: DatabaseReference = Database.database().reference()
    let user = "FakeUser"
    
    func updateNewMenu(recipeName: [String], date: String, recipeInformation: [RecipeCalendarRealmModel]) {
        self.ref.child("menu/\(user)/\(date)").setValue([
            "recipes": recipeName
            ])
        //update menu
        recipeRealmModelToFirebase(recipeInformation: recipeInformation)
    }
    
    
    func recipeRealmModelToFirebase(recipeInformation: [RecipeCalendarRealmModel]) {
        for recipe in recipeInformation {
            guard let recipeRealmModel = recipe.recipeRealmModel else {return}
            let ingredients = recipeIngredientRealmModelToDictionary(recipeIngredients: Array(recipeRealmModel.ingredients))
            let nuitrients = recipeNuitrientRealmModelToDictionary(recipeNuitrients: Array(recipeRealmModel.nutrients))
            self.ref.child("recipe/\(recipeRealmModel.label)").setValue([
                "url": recipeRealmModel.url,
                "image": recipeRealmModel.image,
                "ingredients": ingredients,
                "nuitrients": nuitrients
                ])
        }
    }
    
    
    func recipeIngredientRealmModelToDictionary(recipeIngredients: [IngredientRecipeModel])
        -> [[String: Any]]
    {
        var ingredientDictionary = [[String: Any]]()
        for index in 0...recipeIngredients.count-1 {
            var tempDictionary = [String: Any]()
            tempDictionary["name"] = recipeIngredients[index].name
            tempDictionary["weight"] = recipeIngredients[index].weight
            ingredientDictionary.append(tempDictionary)
        }
        return ingredientDictionary
    }
    
    
    func recipeNuitrientRealmModelToDictionary(recipeNuitrients: [Nutrients]) -> [[String: Any]] {
        var nuitrientsDictionary = [[String: Any]]()
        for index in 0...recipeNuitrients.count-1 {
            var tempDictionary = [String: Any]()
            tempDictionary["label"] = recipeNuitrients[index].label
            tempDictionary["quantity"] = recipeNuitrients[index].quantity
            nuitrientsDictionary.append(tempDictionary)
        }
        return nuitrientsDictionary
    }
    
    
    func updateRecipe(recipeName: String, recipeInformation: RecipeCalendarRealmModel) {
        //check this recipe exist or not
        findRecipe(recipeName: recipeName) { (exist) in
            if exist == false {
                //if this recipe doesn't exist in the database, add this recipe into firebase
                self.recipeRealmModelToFirebase(recipeInformation: [recipeInformation])
            }
        }
        
    }
    
    
    
    func findRecipe(recipeName: String, completion: @escaping (Bool)->Void)  {
        //find whether this recipe exists in the database or not
        let localRef = self.ref.child("recipe")
        let query = localRef.queryOrderedByKey().queryEqual(toValue: recipeName)
        query.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                if result.count > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
