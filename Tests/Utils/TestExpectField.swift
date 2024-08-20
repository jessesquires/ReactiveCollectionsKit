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

enum TestExpectField: String, Hashable {
    case configure
    case didSelect = "did_select"
    case willDisplay = "will_display"
    case didEndDisplaying = "did_end_displaying"
    case didHighlight = "did_highlight"
    case didUnhighlight = "did_unhighlight"
}
