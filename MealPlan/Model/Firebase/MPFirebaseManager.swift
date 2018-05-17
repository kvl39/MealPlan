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
    
    func updateNewMenu(recipeName: [String], date: String) {
        self.ref.child("menu/\(user)/\(date)").setValue([
            "recipes": recipeName
            ])
    }
    
    
    
    func updateRecipe(recipeName: String, recipeInformation: RecipeInformation) {
        //if this recipe already exists in the database, do nothing
        //if this recipe doesn't exist in the database, add this recipe into firebase
    }
    
    
    
    func findRecipe(recipeName: String) {
        //find whether this recipe exists in the database or not
        let localRef = self.ref.child("recipes")
        let query = localRef.queryOrderedByKey().queryEqual(toValue: recipeName)
        query.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                print(result)
            }
        }
    }
}
