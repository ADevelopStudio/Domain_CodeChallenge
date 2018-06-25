//
//  LoadingImageView.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var imageLoader = ImageLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .groupTableViewBackground
        self.setAsEmpty()
        self.addSubview(loadingIndicator, constraints: {
            $0.edges(.bottom).pinToSuperviewMargins()
            $0.centerX.alignWithSuperview()
        })
    }
    

    func fillWith(_ propertyMedias: [Media])  {
        guard let firstImage = propertyMedias.first(where: {$0.mediaType == "image" && !$0.imageUrl.isEmpty}) else {return}
        self.downloadImageFrom(urlString: firstImage.imageUrl)
    }
    
    private func downloadImageFrom(urlString: String) {
        self.loadingIndicator.startAnimating()
        imageLoader.downloadImageFrom(urlString: urlString) { (image) in
            self.loadingIndicator.stopAnimating()
            if let image = image {
                self.contentMode = .scaleToFill
                self.image = image
            } else {
                self.setError()
            }
        }
    }
    
    func setAsEmpty()  {
        self.contentMode = .center
        imageLoader.imageLoadingDataTask?.cancel()
        self.image = #imageLiteral(resourceName: "imagePlaceholder")
    }
    
    func setError()  {
        self.contentMode = .center
        self.image = #imageLiteral(resourceName: "imageError")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
