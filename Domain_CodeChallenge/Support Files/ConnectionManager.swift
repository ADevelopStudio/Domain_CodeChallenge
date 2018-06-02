//
//  Connections.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit

let connectionManager = ConnectionManager()

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}


struct ConnectionManager {
    let domainBaseUrl = "https://domain-adapter-api.domain.com.au/v1/search"
    
    func downloadImageFrom(urlString: String, completion: @escaping (UIImage?)->()) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let cachedImage = Constants.imageCache.object(forKey:  url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let img = UIImage(data: data)
            DispatchQueue.main.async {
                completion(img)
                if img != nil {
                    Constants.imageCache.setObject(img!, forKey:  url.absoluteString as NSString)
                }
            }
            }.resume()
    }
    
    func getData(typeOfRequest: TypeOfRequest, completion: @escaping (_ results: [Property], _ errorMessage: String)->()) {
        guard let url = URL(string: domainBaseUrl) else {
            completion([], "Error creating url")
            return
        }
        let json: [String: Any] = ["search_mode": typeOfRequest.name.lowercased(),
                                   "dwelling_types": ["Apartment / Unit / Flat"]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
//                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
//                    throw JSONError.ConversionFailed
//                }
//                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let jsonSearchResults  = try? decoder.decode(SearchResults.self, from: data) else {
                    throw JSONError.ConversionFailed
                }
                print(jsonSearchResults.searchResults.count)
                DispatchQueue.main.async {
                    completion(jsonSearchResults.searchResults, "")
                }
            } catch let error as JSONError {
//                print(error.rawValue)
                DispatchQueue.main.async {
                    completion([], error.rawValue)
                }
            } catch let error as NSError {
//                print(error.debugDescription)
                DispatchQueue.main.async {
                    completion([], error.debugDescription)
                }
            }
            }.resume()
    }
    
}
