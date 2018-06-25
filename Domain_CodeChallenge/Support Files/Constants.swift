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
    func jsonData() -> Data? {
        let json: [String: Any] = ["search_mode": self.name.lowercased(),
                                   "dwelling_types": ["Apartment / Unit / Flat"]]
        return try? JSONSerialization.data(withJSONObject: json)
    }
}

struct Constants {
    static var imageCache = NSCache<NSString, UIImage>()
    
    static var favouriteList: Set<Int> =  Set(UserDefaults.standard.object(forKey: "FavoriteList") as? Array<Int> ?? [])
    
    
    static func saveFavouriteList()  {
        UserDefaults.standard.set(Array(self.favouriteList), forKey: "FavoriteList")
        NotificationCenter.default.post(name: Notification.Name("FavoriteCounterDidChange"), object: nil)
    }
}


