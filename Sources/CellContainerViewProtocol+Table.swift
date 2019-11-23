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

/// Conformance to `CellContainerViewProtocol`.
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
    public func dequeueReusableCell(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCell(viewClass: AnyClass?, identifier: String) {
        self.register(viewClass, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCell(nib: UINib?, identifier: String) {
        self.register(nib, forCellReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryView(kind: SupplementaryViewKind,
                                                 identifier: String,
                                                 indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryView(viewClass: AnyClass?,
                                          kind: SupplementaryViewKind,
                                          identifier: String) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryView(nib: UINib?,
                                          kind: SupplementaryViewKind,
                                          identifier: String) {
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
