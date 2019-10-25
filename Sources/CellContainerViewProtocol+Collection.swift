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
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func registerCellClass(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerCellNib(_ cellNib: UINib?, identifier: String) {
        self.register(cellNib, forCellWithReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                                    identifier: String,
                                                    indexPath: IndexPath) -> SupplementaryViewType? {
        self.dequeueReusableSupplementaryView(ofKind: kind.collectionElementKind,
                                              withReuseIdentifier: identifier,
                                              for: indexPath)
    }

    /// :nodoc:
    public func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                               kind: SupplementaryViewKind,
                                               identifier: String) {
        self.register(supplementaryClass,
                      forSupplementaryViewOfKind: kind.collectionElementKind,
                      withReuseIdentifier: identifier)
    }

    /// :nodoc:
    public func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                             kind: SupplementaryViewKind,
                                             identifier: String) {
        self.register(supplementaryNib,
                      forSupplementaryViewOfKind: kind.collectionElementKind,
                      withReuseIdentifier: identifier)
    }
}
