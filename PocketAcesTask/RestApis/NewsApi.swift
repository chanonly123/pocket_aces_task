//
//  ApiConfig.swift
//  WeatherTest
//
//  Created by Chandan Karmakar on 03/10/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

class NewsApi {
    
    static func getTopHeadline(page: Int, handler: @escaping ResponseHandler<NewsTopHeadlinesData>) {
        RestApi.call(url: Apis.allContacts, params: ["apiKey": EnvDev.newsapiKey, "country": "us", "page": page, "pageSize": 10], handler: handler)
    }
    
    static func search(query: String, page: Int, handler: @escaping ResponseHandler<NewsTopHeadlinesData>) {
        RestApi.call(url: Apis.allContacts, params: ["apiKey": EnvDev.newsapiKey, "country": "us", "page": page, "pageSize": 10], handler: handler)
    }

    
}
