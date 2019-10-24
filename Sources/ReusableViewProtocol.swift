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

/// This protocol unifies cells and supplementary views for
/// collections and tables by providing a common interface.
public protocol ReusableViewProtocol {

    // MARK: Associated types

    /// The container view of the cell or supplementary view.
    ///
    /// For example, for `UICollectionViewCell` this is `UICollectionView`,
    /// and for `UITableViewCell` this is `UITableView`.
    associatedtype ContainerView: UIView & CellContainerViewProtocol

    // MARK: Properties

    /// A string that identifies the purpose of the view.
    var reuseIdentifier: String? { get }

    // MARK: Methods

    /// Performs any clean up necessary to prepare the view for use again.
    func prepareForReuse()
}

extension UICollectionReusableView: ReusableViewProtocol {

    /// :nodoc:
    public typealias ContainerView = UICollectionView
}

extension UITableViewCell: ReusableViewProtocol {

    /// :nodoc:
    public typealias ContainerView = UITableView
}

extension UITableViewHeaderFooterView: ReusableViewProtocol {

    /// :nodoc:
    public typealias ContainerView = UITableView
}
