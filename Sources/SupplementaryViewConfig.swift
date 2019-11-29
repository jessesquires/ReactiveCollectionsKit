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

public struct SupplementaryViewConfig {
    public typealias ViewType = UIView & ReusableViewProtocol

    public let apply: (ViewType) -> Void
}
