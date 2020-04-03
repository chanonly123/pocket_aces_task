//
//  News.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation

struct NewsTopHeadlines: Codable {

    var success: Bool?
    var code: Int?
    var data: Data?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case code = "code"
        case data = "data"
    }
}
