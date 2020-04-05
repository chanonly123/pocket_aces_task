//
//  ApiConfig.swift
//  WeatherTest
//
//  Created by Chandan Karmakar on 03/10/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

class NewsApi {
    
    static func getTopHeadline(page: Int, input: HeadlineNewsInput, handler: @escaping ResponseHandler<NewsTopHeadlinesData>) {
        var params: [String : Any] = ["apiKey": EnvDev.newsapiKey, "page": page]
        switch input {
        case .country(let country):
            params["country"] = country.code ?? ""
        case .source(let source):
            params["sources"] = source.id ?? ""
        }
        RestApi.call(url: Apis.topHeadlines, params: params, handler: handler)
    }
    
    static func getSearchEverything(query: String, page: Int, handler: @escaping ResponseHandler<NewsTopHeadlinesData>) {
        RestApi.call(url: Apis.searchEverything, params: ["apiKey": EnvDev.newsapiKey, "page": page, "q": query], handler: handler)
    }

    static func getAllSources(country: CountryEntry, handler: @escaping ResponseHandler<SourcesData>) {
        RestApi.call(url: Apis.allSources, params: ["apiKey": EnvDev.newsapiKey, "country": country.code ?? ""], handler: handler)
    }
}

