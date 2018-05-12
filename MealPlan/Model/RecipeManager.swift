//
//  RecipeManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

protocol RecipeManagerProtocol: class {

    func manager(_ manager: RecipeManager, didGet products: RecipeModel)

    func manager(_ manager: RecipeManager, didFailWith error: MPError)

}

struct RecipeManager {

    weak var delegate: RecipeManagerProtocol?
    let recipeProvider = RecipeProvider()

    func getRecipe(keyWord: String) {

        recipeProvider.getRecipe(keyword: keyWord, success: { (recipe) in

            print(recipe)
            self.delegate?.manager(self, didGet: recipe)

        }) { (error) in
            print(error)
        }

    }

}
