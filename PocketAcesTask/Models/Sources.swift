//
//  Sources.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation

class SourcesData: Codable {

    var status: String?
    var sources: [SourceEntry]?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case sources = "sources"
        case message = "message"
    }
}

class SourceEntry: Codable {

    var language: String?
    var country: String?
    var name: String?
    var description: String?
    var category: String?
    var id: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case language = "language"
        case country = "country"
        case name = "name"
        case description = "description"
        case category = "category"
        case id = "id"
        case url = "url"
    }

}
