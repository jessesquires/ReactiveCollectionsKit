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

extension UIViewController {
    func appendRightBarButton(_ item: UIBarButtonItem) {
        var items = self.navigationItem.rightBarButtonItems ?? []
        items.append(item)
        self.navigationItem.rightBarButtonItems = items
    }

    func addShuffle(action: Selector?) {
        let item = UIBarButtonItem(systemImage: "shuffle", target: self, action: action)
        self.appendRightBarButton(item)
    }

    func addReload(action: Selector?) {
        let item = UIBarButtonItem(systemImage: "arrow.clockwise", target: self, action: action)
        self.appendRightBarButton(item)
    }
}
