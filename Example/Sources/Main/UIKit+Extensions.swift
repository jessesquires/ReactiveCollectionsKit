//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/ReactiveCollectionsKit
//
//  GitHub
//  https://github.com/jessesquires/ReactiveCollectionsKit
//
//  Copyright © 2019-present Jesse Squires
//

import UIKit

extension UIBarButtonItem {
    convenience init(systemImage: String, target: Any?, action: Selector?) {
        self.init(image: UIImage(systemName: systemImage),
                  style: .plain,
                  target: target,
                  action: action)
    }
}
