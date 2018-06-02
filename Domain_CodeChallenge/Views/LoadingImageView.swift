//
//  LoadingImageView.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .blue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .groupTableViewBackground
        self.contentMode = .center
        self.image = #imageLiteral(resourceName: "imagePlaceholder")
        self.addSubview(loadingIndicator, constraints: {
            $0.centerX.alignWithSuperview()
            $0.centerY.alignWithSuperview()
        })
    }
    
    func downloadImageFrom(urlString: String, imageMode: UIViewContentMode) {
        guard let url = URL(string: urlString) else {
            self.setError()
            return
        }
        downloadImageFrom(url)
    }
    func setError()  {
        self.contentMode = .center
        self.image = #imageLiteral(resourceName: "imageError")
    }
    
    func downloadImageFrom(_ url: URL) {
        if let cachedImage = Constants.imageCache.object(forKey:  url.absoluteString as NSString) {
            self.contentMode = .scaleAspectFit
            self.image = cachedImage
        } else {
            self.loadingIndicator.startAnimating()
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    guard let imageToCache =  UIImage(data: data) else {
                        self.setError()
                        return
                    }
                    self.contentMode = .scaleAspectFit
                    Constants.imageCache.setObject(imageToCache, forKey:  url.absoluteString as NSString)
                    self.image = imageToCache
                }
                }.resume()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
