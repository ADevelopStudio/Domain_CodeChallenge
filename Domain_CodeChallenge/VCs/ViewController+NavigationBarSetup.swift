//
//  ViewController+SegmentSwitcher.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func setupNavigationBar()  {
        self.navigationItem.titleView = segmenter
        segmenter.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        favoriteCounter = UIBarButtonItem(title: "☆: \(Constants.favouriteList.count)", style: .plain, target: self, action: #selector(self.resetFavourites))
        self.navigationItem.setRightBarButtonItems([favoriteCounter!], animated: false)
    }
    
    
    @objc func resetFavourites(){
        UIApplication.shared.tapFeedback()
        if  Constants.favouriteList.isEmpty {return}
        let alert = UIAlertController(title: "Clear favourite list", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: { _ in
            Constants.favouriteList = []
            Constants.saveFavouriteList()
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
