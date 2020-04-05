//
//  Country.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation

class CountryCodeData: Codable {

    var data: [CountryEntry]?

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

class CountryEntry: Codable, Equatable {
    static func == (lhs: CountryEntry, rhs: CountryEntry) -> Bool {
        return lhs.code == rhs.code
    }
    

    var code: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
    
    static func createMyCountry() -> CountryEntry {
        let country = CountryEntry()
        country.code = Locale.current.regionCode ?? "IN"
        country.name = Locale.current.localizedString(forRegionCode: country.code ?? "IN") ?? "India"
        return country
    }
}
