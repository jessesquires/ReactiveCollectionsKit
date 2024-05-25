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

import ReactiveCollectionsKit
import UIKit

extension UIBarButtonItem {
    convenience init(systemImage: String, target: Any?, action: Selector?) {
        self.init(image: UIImage(systemName: systemImage),
                  style: .plain,
                  target: target,
                  action: action)
    }
}

extension UIAction {
    convenience init(
        title: String,
        systemImage: String,
        attributes: UIMenuElement.Attributes = .init(),
        handler: @escaping UIActionHandler
    ) {
        self.init(
            title: title,
            image: UIImage(systemName: systemImage),
            attributes: attributes,
            handler: handler
        )
    }
}

extension UIContextMenuConfiguration {
    typealias ItemAction = (UniqueIdentifier) -> Void

    static func configFor(
        itemId: UniqueIdentifier,
        favoriteAction: @escaping ItemAction,
        deleteAction: @escaping ItemAction) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let favorite = UIAction(title: "Favorite",
                                    image: UIImage(systemName: "star.fill")) { _ in
                favoriteAction(itemId)
            }

            let delete = UIAction(title: "Delete",
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive) { _ in
                deleteAction(itemId)
            }

            return UIMenu(children: [favorite, delete])
        }
    }
}
