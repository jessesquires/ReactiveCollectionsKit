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
