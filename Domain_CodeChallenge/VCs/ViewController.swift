//
//  ViewController.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let favoriteCounter =  UIBarButtonItem(title: "☆: 0", style: .plain, target: nil, action: nil)
    
    lazy var segmenter: UISegmentedControl = {
        let segControl = UISegmentedControl(items: TypeOfRequest.allValues.map({$0.name}))
        segControl.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        segControl.selectedSegmentIndex = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupNavigationBar()
        self.loadData()
    }
    
    @objc func loadData()  {
        print("Load Data \(TypeOfRequest.allValues[segmenter.selectedSegmentIndex])")
    }
}

