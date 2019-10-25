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

extension UITableView: CellContainerViewProtocol {

    /// :nodoc:
    public typealias CellType = UITableViewCell

    /// :nodoc:
    public typealias SupplementaryViewType = UITableViewHeaderFooterView

    /// :nodoc:
    public typealias DataSource = UITableViewDataSource

    /// :nodoc:
    public typealias Delegate = UITableViewDelegate

    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCellClass(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCellNib(_ cellNib: UINib?, identifier: String) {
        self.register(cellNib, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                                    identifier: String,
                                                    indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                               kind: SupplementaryViewKind,
                                               identifier: String) {
        self.register(supplementaryClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                             kind: SupplementaryViewKind,
                                             identifier: String) {
        self.register(supplementaryNib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
