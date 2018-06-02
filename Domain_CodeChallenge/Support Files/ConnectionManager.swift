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

struct ConnectionManager {
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
    
}
