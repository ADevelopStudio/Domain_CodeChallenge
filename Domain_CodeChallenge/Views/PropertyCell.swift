//
//  PropertyCell.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class PropertyCell: UICollectionViewCell {
    private let descriptionLabelHeight: CGFloat  = 50
    private var imageView: LoadingImageView = LoadingImageView(frame: .zero)

    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkText
        return label
    }()
    
    let favoriteBtn = FavouriteButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.setAsEmpty()
    }
    
    func createView()  {
        self.addSubview(imageView, descriptionLabel, favoriteBtn, constraints: { v1, v2, v3 in
            v1.edges.pinToSuperview(insets: UIEdgeInsets(top: 0, left: 0, bottom: self.descriptionLabelHeight + 5, right: 0), relation: .equal)
            v2.edges(.right, .left,.bottom).pinToSuperviewMargins()
            v2.height.set(self.descriptionLabelHeight)
            v3.height.set(40)
            v3.width.set(40)
            v3.edges(.top, .left).pinToSuperviewMargins()
        })
        self.backgroundColor = .groupTableViewBackground
    }
    

    func fillWith(property: Property, onFavoriteTap: @escaping (FavouriteButton)->())  {
        self.favoriteBtn.onTap = onFavoriteTap
        self.favoriteBtn.setFavorite(property.isFavorite)
        self.descriptionLabel.text = property.address
        self.imageView.fillWith(property.media)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
