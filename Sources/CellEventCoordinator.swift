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

import Foundation
import UIKit

/// Conforming objects are responsible for handling various cell events.
@MainActor
public protocol CellEventCoordinator: AnyObject {

    /// Called when a cell is selected.
    /// - Parameter viewModel: The cell view model that corresponds to the cell.
    func didSelectCell(viewModel: any CellViewModel)

    /// Called when a cell is deselected.
    /// - Parameter viewModel: The cell view model that corresponds to the cell.
    func didDeselectCell(viewModel: any CellViewModel)

    /// Returns the underlying view controller that owns the collection view for the cell.
    ///
    /// You may use this to optionally handle navigation within your cell view model.
    var underlyingViewController: UIViewController? { get }
}

extension CellEventCoordinator {

    /// Default implementation. Does nothing.
    public func didSelectCell(viewModel: any CellViewModel) { }

    /// Default implementation. Does nothing.
    public func didDeselectCell(viewModel: any CellViewModel) { }

    /// Default implementation. Returns `nil`.
    public var underlyingViewController: UIViewController? { nil }
}

extension CellEventCoordinator where Self: UIViewController {

    /// Default implementation if the conformer is a `UIViewController`.
    /// Returns `self`.
    public var underlyingViewController: UIViewController? { self }
}
