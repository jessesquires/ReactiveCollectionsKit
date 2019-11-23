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
extension UICollectionView: CellContainerViewProtocol {

    /// :nodoc:
    public typealias CellType = UICollectionViewCell

    /// :nodoc:
    public typealias SupplementaryViewType = UICollectionReusableView

    /// :nodoc:
    public typealias DataSource = UICollectionViewDataSource

    /// :nodoc:
    public typealias Delegate = UICollectionViewDelegate

    /// :nodoc:
    public func dequeueReusableCell(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCell(viewClass: AnyClass?, identifier: String) {
        self.register(viewClass, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCell(nib: UINib?, identifier: String) {
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryView(kind: SupplementaryViewKind,
                                                 identifier: String,
                                                 indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableSupplementaryView(ofKind: kind._collectionElementKind,
                                              withReuseIdentifier: identifier,
                                              for: indexPath)
    }

    /// :nodoc:
    public func registerSupplementaryView(viewClass: AnyClass?,
                                          kind: SupplementaryViewKind,
                                          identifier: String) {
        self.register(viewClass,
                      forSupplementaryViewOfKind: kind._collectionElementKind,
                      withReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryView(nib: UINib?,
                                          kind: SupplementaryViewKind,
                                          identifier: String) {
        self.register(nib,
                      forSupplementaryViewOfKind: kind._collectionElementKind,
                      withReuseIdentifier: identifier)
    }
}
