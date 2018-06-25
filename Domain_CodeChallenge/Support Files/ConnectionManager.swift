//
//  Connections.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit

enum JSONError: String, Error {
    case NoData = ""
    case ConversionFailed = "ERROR: conversion from JSON failed"
}


struct ImageLoader {
    var imageLoadingDataTask: URLSessionDataTask?
    mutating func downloadImageFrom(urlString: String, completion: @escaping (UIImage?)->()) {
        imageLoadingDataTask?.cancel()
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let cachedImage = Constants.imageCache.object(forKey:  url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        imageLoadingDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            let img = UIImage(data: data)
            DispatchQueue.main.async {
                completion(img)
                if img != nil {
                    Constants.imageCache.setObject(img!, forKey:  url.absoluteString as NSString)
                }
            }
        }
        imageLoadingDataTask?.resume()
    }
}



struct ConnectionManager {
    static let domainBaseUrl = "https://domain-adapter-api.domain.com.au/v1/search"
    static var getDataTask: URLSessionDataTask?

    static func getData(typeOfRequest: TypeOfRequest, completion: @escaping (_ results: [Property], _ errorMessage: String)->()) {
        getDataTask?.cancel()
        guard let url = URL(string: domainBaseUrl) else {
            completion([], "Error creating url")
            return
        }
        UserDefaults.standard.set(TypeOfRequest.allValues.index(of: typeOfRequest) ?? 0, forKey: "TypeOfRequest")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = typeOfRequest.jsonData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        getDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let jsonSearchResults  = try? decoder.decode(SearchResults.self, from: data) else {
                    throw JSONError.ConversionFailed
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(jsonSearchResults.searchResults, "")
                }
            } catch let error as JSONError {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion([], error.rawValue)
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion([], error.debugDescription)
                }
            }
            }
        getDataTask?.resume()
    }
    
}
