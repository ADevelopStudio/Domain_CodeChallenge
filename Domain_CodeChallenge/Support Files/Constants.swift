//
//  Constants.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit

enum TypeOfRequest {
    static let allValues = [TypeOfRequest.buy , .rent]
    case buy, rent
    var  name: String {
        switch self {
        case .buy:
            return "Buy"
        case .rent:
            return "Rent"
        }
    }
}

struct Constants {
    static var imageCache = NSCache<NSString, UIImage>()
    static var favouriteList: Set<Int> =  Set(UserDefaults.standard.object(forKey: "FavoriteList") as? Array<Int> ?? [])

    static func saveFavouriteList()  {
         UserDefaults.standard.set(Array(self.favouriteList), forKey: "FavoriteList")
    }
}


