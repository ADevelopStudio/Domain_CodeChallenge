//
//  Constants.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation

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
