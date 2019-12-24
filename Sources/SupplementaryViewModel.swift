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

public protocol SupplementaryViewModel: DiffableViewModel {
    var kind: SupplementaryViewKind { get }

    var style: SupplementaryViewStyle { get }

    #warning("TODO: header/footer view size")
}

extension SupplementaryViewModel {

    var _registration: ReusableViewRegistration? {
        switch self.style {
        case let .customView(registration, _):
            return registration

        case .title:
            assertionFailure("Attempt to access customView for a title-based supplementary view")
            return nil
        }
    }

    func _apply(to view: SupplementaryViewConfig.ViewType) {
        switch self.style {
        case let .customView(_, config):
            config.apply(view)

        case .title:
            assertionFailure("Attempt to apply config to a title-based supplementary view")
        }
    }

    var _title: String? {
        switch self.style {
        case let .title(text):
            return text

        case .customView:
            assertionFailure("Attempt to access title for a customView-based supplementary view")
            return nil
        }
    }

    var _isTitleBased: Bool {
        switch self.style {
        case .title: return true
        case .customView: return false
        }
    }

    var _isCustomViewBased: Bool {
        switch self.style {
        case .title: return false
        case .customView: return true
        }
    }
}
