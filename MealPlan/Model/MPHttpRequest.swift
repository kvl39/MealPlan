//
//  MPHttpRequest.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/4.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import Foundation

enum MPHttpMethod: String {

    case post = "POST"

    case get = "GET"

    case patch = "PATCH"

    case delete = "DELETE"
}

protocol MPHttpRequest {

    func urlMethod() -> MPHttpMethod

    func urlParameter() -> String

    func urlString() -> String

    func requestBody() -> [String: Any]

    func request() throws -> URLRequest

}

extension MPHttpRequest {

    func urlString() -> String {

        return "https://api.edamam.com/search" + urlParameter()

    }

    func requestBody() -> [String: Any] { return [:] }

    func request() throws -> URLRequest {

        let url = URL(string: urlString())

        guard let MPurl = url else {
            throw MPError.BadURL
        }

        var request = URLRequest(url: MPurl)

        request.httpMethod = urlMethod().rawValue

        return request

    }

}
