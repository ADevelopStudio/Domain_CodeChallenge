//
//  Extentions.swift
//  Domain_CodeChallenge
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import Foundation
import UIKit

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
