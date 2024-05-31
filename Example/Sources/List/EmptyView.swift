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

import Foundation
import ReactiveCollectionsKit
import UIKit

@MainActor let sharedEmptyViewProvider = EmptyViewProvider {
    if #available(iOS 17.0, *) {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No Content"
        config.secondaryText = "The list is empty! Nothing to see here."
        config.image = UIImage(systemName: "exclamationmark.triangle.fill")
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .tertiarySystemBackground
        config.background = background
        return UIContentUnavailableView(configuration: config)
    }

    let label = UILabel()
    label.text = "No Content"
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    label.backgroundColor = .secondarySystemBackground
    return label
}
