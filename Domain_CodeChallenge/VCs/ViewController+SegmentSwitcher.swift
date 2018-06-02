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
        self.navigationItem.setRightBarButtonItems([favoriteCounter], animated: false)
        favoriteCounter.title = "☆: 10"
    }

}
