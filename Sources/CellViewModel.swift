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
    typealias CellType = UIView & ReusableViewProtocol

    var registration: ReusableViewRegistration { get }

    var shouldHighlight: Bool { get }

    var didSelect: CellActions.DidSelect { get }

    /// - Note: for table views the width is ignored
    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize

    func applyViewModelTo(cell: CellType)
}

extension CellViewModel {
    public var shouldHighlight: Bool { true }
}
