//
//  ViewController.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var favoriteCounter: UIBarButtonItem? = nil
    
    lazy var segmenter: UISegmentedControl = {
        let segControl = UISegmentedControl(items: TypeOfRequest.allValues.map({$0.name}))
        segControl.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        segControl.selectedSegmentIndex =  UserDefaults.standard.integer(forKey: "TypeOfRequest")
        return segControl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(PropertyCell.self, forCellWithReuseIdentifier: "PropertyCell")
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var properties = Array<Property>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupNavigationBar()
        self.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavoriteCounter), name: Notification.Name("FavoriteCounterDidChange"), object: nil)
    }
    
    @objc func updateFavoriteCounter(){
        self.favoriteCounter?.title = "☆: \(Constants.favouriteList.count)"
    }
    
    @objc func loadData()  {
        self.properties  = []
        self.collectionView.reloadData()
        ConnectionManager.getData(typeOfRequest: TypeOfRequest.allValues[segmenter.selectedSegmentIndex]) { results, errorMessage in
            self.properties = Array(results.prefix(20)) // enought according to the challenge description
            self.collectionView.reloadData()
            if !errorMessage.isEmpty {self.showError(errorMessage)}
        }
    }
}

