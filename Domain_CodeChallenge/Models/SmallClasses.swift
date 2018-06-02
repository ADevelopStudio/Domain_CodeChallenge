//
//  SmallClasses.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    var searchResults: [Property]
}
struct Property: Codable {
    var id: Int
    var address: String
    var media: [Media]
}
struct Media: Codable {
    var imageUrl: String
    var mediaType: String //image
}
