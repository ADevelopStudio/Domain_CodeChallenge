//
//  SwitcherNavigationController.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = .black
        self.navigationBar.tintColor = .white
    }
}
