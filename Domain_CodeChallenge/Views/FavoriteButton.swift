//
//  FavoriteButton.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit
class FavouriteButton: UIButton {

    var onTap: (()->())? = nil
    var isFavorite = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/2
        self.titleLabel?.font = .systemFont(ofSize: 35, weight: .regular)
        self.setTitleColor(.red, for: [])
        self.setFavorite(isFavorite)
        self.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
    }
    
    func setFavorite(_ isFavorite: Bool)  {
        self.setTitle(isFavorite ? "★" : "☆", for: [])
    }
    
    @objc func tap()  {
        self.setFavorite(true)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}