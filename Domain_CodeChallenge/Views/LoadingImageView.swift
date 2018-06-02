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
    
    func downloadImageFrom(urlString: String) {
        self.loadingIndicator.startAnimating()
        connectionManager.downloadImageFrom(urlString: urlString) { (image) in
            self.loadingIndicator.stopAnimating()
            if let image = image {
                self.contentMode = .scaleAspectFit
                self.image = image
            } else {
                self.setError()
            }
        }
    }
    
    func setError()  {
        self.contentMode = .center
        self.image = #imageLiteral(resourceName: "imageError")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
