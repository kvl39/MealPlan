//
//  MPHttpClient.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation
import Alamofire

class MPHttpClient {
    
    static let httpClient = MPHttpClient()
    
    private let queue: DispatchQueue
    
    private init() {
        queue = DispatchQueue(label: String(describing: MPHttpClient.self), qos: .default, attributes: .concurrent)
    }
    
    func request(_ httpRequest: MPHttpRequest,
                 success: @escaping (Data)->Void,
                 failure: @escaping (Error)->Void)->DataRequest?{
        
        do{
            return try request(httpRequest.request(), success: success,failure: failure)
        } catch {
            failure(error)
             return nil
        }
        
    }
    
    private func request(_ request: URLRequestConvertible,
                         success: @escaping (Data)->Void,
                         failure: @escaping (Error)->Void)->DataRequest {
        
        return Alamofire.SessionManager.default.request(request).validate().responseData(queue: self.queue) { (response) in
            
//            switch response.result{
//            case .success(let data): success(data)
//            case .failure(let error): failure(error)
//            }
            
//            if response.result.isSuccess {
//                success(responseObject.result.value! as! [String : Any])
//            }
            
            if response.result.isSuccess {
                let string1 = String(data: response.result.value!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print(string1)
                success(response.result.value!)
            } else {
                failure(response.result.error!)
            }
            
        }
    }
}
