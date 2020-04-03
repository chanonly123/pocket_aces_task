//
//  String.swift
//  GoContacts
//
//  Created by Chandan Karmakar on 28/11/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
