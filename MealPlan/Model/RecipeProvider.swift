//
//  RecipeProvider.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

private enum RecipeAPI: MPHttpRequest {
    case getRecipeWithKeyword(String)
    
    func urlMethod() -> MPHttpMethod {
        switch self {
        case .getRecipeWithKeyword(let keyWord):
            return .get
        default:
            return .get
        }
    }
    
    func urlParameter() -> String {
        switch self{
        case .getRecipeWithKeyword(let keyWord):
            return keyWord
        default:
            return ""
        }
    }
}


class RecipeProvider {
    
    private var httpClient = MPHttpClient.httpClient
    
    private let decoder = JSONDecoder()
    
    func getRecipe(keyword: String,
                   success: @escaping (RecipeModel)->Void,
                   failure: @escaping (MPError)->Void) {
        
        httpClient.request(RecipeAPI.getRecipeWithKeyword(keyword), success: { (data) in
            
            do {

                
//                let serializedData = try JSONSerialization.data(withJSONObject: [String: Any].self, options: .prettyPrinted)
//                let reqString = String(data: serializedData, encoding: .utf8)
//                let data1 = reqString?.data(using: .utf8)
                let response = try self.decoder.decode(RecipeModel.self, from: data)
                success(response)
            } catch {
                failure(.JSONNotDecodable)
            }
            
        }) { (error) in
            failure(.RequestFail)
        }
        
        
    }
    
    
}
