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
    
    var isFavorite: Bool {
        return  Constants.favouriteList.contains(self.id)
    }
    
    func addRemoveFromFavourites()  {
        if Constants.favouriteList.contains(self.id) {
            Constants.favouriteList.remove(self.id)
        } else {
            Constants.favouriteList.insert(self.id)
        }
        Constants.saveFavouriteList()
    }
}

struct Media: Codable {
    var imageUrl: String
    var mediaType: String //image
}
