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
    
    var imageView: UIImageView = {
        let imgview = UIImageView(frame: .zero)
        imgview.contentMode = .scaleAspectFit
        imgview.clipsToBounds = true
        return imgview
    }()
    
    lazy var descr: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame.height < descriptionLabelHeight {return}
        self.createView()
    }
    
    func createView()  {
        self.addSubview(imageView, descr, constraints: { v1, v2 in
            v1.edges.pinToSuperview(insets: UIEdgeInsets(top: 0, left: 0, bottom: self.descriptionLabelHeight, right: 0), relation: .equal)
            v2.edges(.right, .left,.bottom).pinToSuperview()
            v2.height.set(self.descriptionLabelHeight)
        })
        imageView.backgroundColor = .yellow
        descr.text = "test me now"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
