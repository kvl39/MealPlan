////
////  RecipeCalendarModel.swift
////  MealPlan
////
////  Created by Liao Kevin on 2018/5/9.
////  Copyright © 2018年 Kevin Liao. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//class CompleteLikeArticle: Object {
//    //    id, title, pictures(url array),place,authorname, Interest, interested_in, content, authorImage, authorImageURL, placeImage, placeImageDidLoad, placeImageURL,
//    @objc dynamic var id = ""
//    @objc dynamic var title = ""
//    let placeImageURLs = List<PlaceImageURLObject>()
//    @objc dynamic var place = ""
//    @objc dynamic var authorName = ""
//    @objc dynamic var interest = false
//    @objc dynamic var interested_in = 0
//    @objc dynamic var content = ""
//    @objc dynamic var authorImage: Data?
//    @objc dynamic var authorImageURL = ""
//    @objc dynamic var placeImage: Data?
//    @objc dynamic var placeImageDidLoad = false
//    @objc dynamic var created_time = 0
//}
//
//class RecipeCalendarRealmModel: Object {
//    @objc dynamic var recipeDay = Date(timeIntervalSince1970: 1)
//    //@objc dynamic var RecipeRealmModel
//}
//
//class RecipeRealmModel: Object {
//    @objc dynamic var url = ""
//    @objc dynamic var label = ""
//    @objc dynamic var image = ""
//    let Ingredients = List<IngredientRecipeModel>
//}
//
//class IngredientRecipeModel: Object {
//    @objc dynamic var name = ""
//    @objc dynamic var weight = 0.0
//}
//
//
