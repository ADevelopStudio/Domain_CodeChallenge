//
//  Extentions.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension UITraitCollection {
    func numberOfRowsInCollectionView() -> CGFloat  {
        switch self.horizontalSizeClass {
        case .compact:
            return 1
        case .regular:
            return 2
        case .unspecified:
            return 2
        }
    }
}
