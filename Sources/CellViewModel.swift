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

public protocol CellViewModel: DiffableViewModel {
    var registration: ReusableViewRegistration { get }

    var shouldHighlight: Bool { get }

    var didSelect: CellActions.DidSelect { get }

    func apply(to cell: UICollectionViewCell)
}

extension CellViewModel {
    public var shouldHighlight: Bool { true }
}
