//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

public enum SupplementaryViewStyle {
    case customView(ReusableViewRegistration)
    case title(String)
}

public protocol SupplementaryViewModel {
    typealias SupplementaryViewType = UIView & ReusableViewProtocol

    var style: SupplementaryViewStyle { get }

    var kind: SupplementaryViewKind { get }

    func applyViewModelTo(view: SupplementaryViewType)
}
