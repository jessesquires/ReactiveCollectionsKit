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

/// This protocol unifies cells and supplementary views for
/// collections and tables by providing a common interface.
public protocol ReusableViewProtocol: AnyObject {

    /// A string that identifies the purpose of the view.
    var reuseIdentifier: String? { get }

    /// Performs any clean up necessary to prepare the view for use again.
    func prepareForReuse()
}

extension UICollectionReusableView: ReusableViewProtocol { }

extension UITableViewCell: ReusableViewProtocol { }

extension UITableViewHeaderFooterView: ReusableViewProtocol { }
