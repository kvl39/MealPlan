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
    
    func uploadNewMenu(date: String, recipeInformation: [RecipeCalendarRealmModel]) {
        recipeRealmModelToFirebase(recipeInformation: recipeInformation, date: date)
    }
    
    
    func recipeRealmModelToFirebase(recipeInformation: [RecipeCalendarRealmModel], date: String) {
        
        var recipeNameArray: [String] = []
        
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
            recipeNameArray.append(recipeRealmModel.label)
        }
        self.ref.child("menu").childByAutoId().setValue([
            "recipes": recipeNameArray
        ]) { (error, databaseReference) in
            self.ref.child("userMenu/\(self.user)").childByAutoId().setValue([
                "reference": databaseReference.key,
                "date": date
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
                //self.recipeRealmModelToFirebase(recipeInformation: [recipeInformation])
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
    
    
    
    func retrieveAllMenu() {
        let localRef = self.ref.child("menu")
        let query = localRef.queryOrdered(byChild: "recipes")
        query.observeSingleEvent(of: .value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    if let recipesName = child.value as? [String: Any],
                       let recipeArray = recipesName["recipes"] as? [String]{
                        //print(recipeArray[0])
                    }
                }
            }
        }
    }
    
    
}
