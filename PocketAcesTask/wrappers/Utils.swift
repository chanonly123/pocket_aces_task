//
//  Utils.swift
//  GoJekContacts
//
//  Created by Chandan Karmakar on 07/11/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

class Utils {
    static func toJsonString(_ dict: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch let error {
            print("JSON parsing error: ", error.localizedDescription)
        }
        return nil
    }
}
