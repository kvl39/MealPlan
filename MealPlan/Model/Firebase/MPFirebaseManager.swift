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
    private let decoder = JSONDecoder()
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
                "label": recipeRealmModel.label,
                "calories": recipeRealmModel.calories,
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
//        findRecipe(recipeName: recipeName) { (exist) in
//            if exist == false {
//                //if this recipe doesn't exist in the database, add this recipe into firebase
//                //self.recipeRealmModelToFirebase(recipeInformation: [recipeInformation])
//            }
//        }
    }
    
    
    
    func findRecipe(recipeName: String,
                    completion: @escaping (Bool, MPFirebaseRecipeModel?)->Void)  {
        //find whether this recipe exists in the database or not
        let localRef = self.ref.child("recipe")
        let query = localRef.queryOrderedByKey().queryEqual(toValue: recipeName)
        query.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                if result.count > 0 {
                    if let recipeInformation = result[0].value as? [String: Any],
                       let calories = recipeInformation["calories"] as? Double,
                       let image = recipeInformation["image"] as? String,
                       let label = recipeInformation["label"] as? String,
                       let url = recipeInformation["url"] as? String,
                       let ingredients = recipeInformation["ingredients"] as? [[String: Any]],
                       let nuitrients = recipeInformation["nuitrients"] as? [[String: Any]] {
                            var ingredientsArray = [MPFirebaseRecipeIngredientModel]()
                            var nuitrientsArray = [MPFirebaseRecipeNuitrientModel]()
                            ingredientsArray = ingredients.map{
                                if let name = $0["name"] as? String,
                                   let weight = $0["weight"] as? Double{
                                    return MPFirebaseRecipeIngredientModel(name: name, weight: weight)
                                }
                                return MPFirebaseRecipeIngredientModel(name: "none", weight: 0.0)
                            }
                            nuitrientsArray = nuitrients.map{
                                if let label = $0["label"] as? String,
                                    let quantity = $0["quantity"] as? Double{
                                    return MPFirebaseRecipeNuitrientModel(label: label, quantity: quantity)
                                }
                                return MPFirebaseRecipeNuitrientModel(label: "none", quantity: 0.0)
                            }
                        print(nuitrientsArray)
                        let recipe = MPFirebaseRecipeModel(calories: calories, image: image, label: label, url: url, ingredients: ingredientsArray, nuitrients: nuitrientsArray)
                        completion(true, recipe)
                    }
                    completion(false, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
    
    
    func findRecipesInMenu(menu: [String], completion: @escaping ([MPFirebaseRecipeModel])-> Void) {
        let targetNumber = menu.count
        var recipeArray: [MPFirebaseRecipeModel] = []
        for recipeName in menu {
            findRecipe(recipeName: recipeName) { (exist, recipe) in
                guard let recipe = recipe else {return}
                recipeArray.append(recipe)
                if (recipeArray.count == targetNumber) {
                    completion(recipeArray)
                    return
                }
            }
        }
    }
    
    
    func retrieveAllMenu(completion: @escaping ([[String]])->Void) {
        let localRef = self.ref.child("menu")
        let query = localRef.queryOrdered(byChild: "recipes")
        var menuArray = [[String]]()
        query.observeSingleEvent(of: .value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    if let recipesName = child.value as? [String: Any],
                       let recipeArray = recipesName["recipes"] as? [String]{
                        menuArray.append(recipeArray)
                    }
                }
            }
            completion(menuArray)
        }
    }

}
