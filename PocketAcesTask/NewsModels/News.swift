//
//  News.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation

class NewsTopHeadlinesData: Codable {

    var status: String?
    var totalResults: Int?
    var articles: [ArticleEntry]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
}

class ArticleEntry: Codable {

    var title: String?
    var url: String?
    var publishedAt: String?
    var content: String?
    var urlToImage: String?
    var author: String?
    var description: String?
    var source: SourceEntry?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case url = "url"
        case publishedAt = "publishedAt"
        case content = "content"
        case urlToImage = "urlToImage"
        case author = "author"
        case description = "description"
        case source = "source"
    }
}

class SourceEntry: Codable {

    var name: String?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}
