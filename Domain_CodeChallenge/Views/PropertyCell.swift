//
//  PropertyCell.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class PropertyCell: UICollectionViewCell {
    let descriptionLabelHeight: CGFloat  = 40
    
    var imageView: LoadingImageView = LoadingImageView(frame: .zero)

    lazy var descr: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    let favoriteBtn = FavouriteButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame.height < descriptionLabelHeight {return}
        self.createView()
    }
    
    func fillWith(isFavorite: Bool, onFavoriteTap: @escaping ()->())  {
        self.favoriteBtn.onTap = onFavoriteTap
        self.favoriteBtn.setFavorite(isFavorite)
    }
    
    func createView()  {
        self.addSubview(imageView, descr, favoriteBtn, constraints: { v1, v2, v3 in
            v1.edges.pinToSuperview(insets: UIEdgeInsets(top: 0, left: 0, bottom: self.descriptionLabelHeight, right: 0), relation: .equal)
            v2.edges(.right, .left,.bottom).pinToSuperview()
            v2.height.set(self.descriptionLabelHeight)
            v3.height.set(40)
            v3.width.set(40)
            v3.edges(.top, .left).pinToSuperviewMargins()
        })
        descr.text = "test me now"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
