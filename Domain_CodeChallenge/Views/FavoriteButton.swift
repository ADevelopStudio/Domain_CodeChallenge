//
//  FavoriteButton.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit
class FavouriteButton: UIButton {

    var isFavorite = false
    var propetry: Property?
    var onTap: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.titleLabel?.font = .systemFont(ofSize: 35, weight: .regular)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.setTitleColor(.red, for: [])
        self.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
    }
    
    func setFavorite(_ isFavorite: Bool)  {
        self.setTitle(isFavorite ? "★" : "☆", for: [])
    }
    
    @objc func tap()  {
        self.bumpAnimation()
        UIApplication.shared.tapFeedback()
        propetry?.addRemoveFromFavourites()
        self.onTap?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
