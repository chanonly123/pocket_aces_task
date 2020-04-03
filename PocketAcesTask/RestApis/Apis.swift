//
//  Apis.swift
//  GoContacts
//
//  Created by Chandan Karmakar on 07/11/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

class Apis {
    static let post = "|POST"
    static let get = "|GET"
    static let put = "|PUT"
    
    static let base = "https://newsapi.org/v2"
    
    static let allContacts = base + "/top-headlines" + get
    
}
