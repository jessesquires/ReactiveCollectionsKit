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

public protocol SupplementaryViewModel {
    typealias SupplementaryViewType = UIView & ReusableViewProtocol

    var kind: SupplementaryViewKind { get }

    var style: SupplementaryViewStyle { get }

    #warning("TODO: move this to Style.customView as a config prop/func. can't style title-based headers/footers")
    func applyViewModelTo(view: SupplementaryViewType)
}

extension SupplementaryViewModel {
    var registration: ReusableViewRegistration? {
        if case let .customView(registration) = self.style {
            return registration
        }
        return nil
    }

    var title: String? {
        if case let .title(text) = self.style {
            return text
        }
        return nil
    }
}
