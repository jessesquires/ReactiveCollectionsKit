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

/// This protocol unifies `UICollectionView` and `UITableView` with a common interface
/// for dequeuing and registering cells and supplementary views.
///
/// It describes a view that is the "container" view for a cell or supplementary view.
/// For `UICollectionViewCell`, this would be `UICollectionView`.
/// For `UITableViewCell`, this would be `UITableView`.
public protocol CellContainerViewProtocol: AnyObject {

    // MARK: Associated types

    /// The type of cell for this container view.
    associatedtype CellType: UIView & ReusableViewProtocol

    /// The type of supplementary view for this container view.
    associatedtype SupplementaryViewType: UIView & ReusableViewProtocol

    /// The type of data source for this container view.
    associatedtype DataSource

    /// The type of delegate for this container view.
    associatedtype Delegate

    // MARK: Properties

    /// The data source for this container view.
    var dataSource: DataSource? { get set }

    /// The delegate for this container view.
    var delegate: Delegate? { get set }

    // MARK: Cells

    /// - Parameters:
    ///   - identifier: The reuse identifier for the specified cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell of type `CellType`.
    func dequeueReusableCell(identifier: String, indexPath: IndexPath) -> CellType

    /// Registers a cell for reuse with the container view.
    /// - Parameters:
    ///   - viewClass: The class of a cell that you want to use in the container view.
    ///   - identifier: The reuse identifier to associate with the specified class.
    func registerCell(viewClass: AnyClass?, identifier: String)

    /// Registers a cell for reuse with the container view.
    /// - Parameters:
    ///   - nib: The nib object containing the cell object.
    ///   - identifier: The reuse identifier to associate with the specified nib file.
    func registerCell(nib: UINib?, identifier: String)

    // MARK: Supplementary views

    /// - Parameters:
    ///   - kind: The kind of supplementary view to retrieve.
    ///   - identifier: The reuse identifier for the specified view.
    ///   - indexPath: The index path specifying the location of the supplementary view in the container view.
    /// - Returns: A reusable supplementary view of type `SupplementaryViewType`.
    func dequeueReusableSupplementaryView(kind: SupplementaryViewKind,
                                          identifier: String,
                                          indexPath: IndexPath) -> SupplementaryViewType?

    /// Registers a supplementary view for reuse with the container view.
    /// - Parameters:
    ///   - viewClass: The class of the view that you want to use in the container view.
    ///   - kind: The kind of supplementary view.
    ///   - identifier: The reuse identifier to associate with the specified class.
    func registerSupplementaryView(viewClass: AnyClass?,
                                   kind: SupplementaryViewKind,
                                   identifier: String)

    /// Registers a supplementary view for reuse with the container view.
    /// - Parameters:
    ///   - nib: The nib object containing the view object.
    ///   - kind: The kind of supplementary view.
    ///   - identifier: The reuse identifier to associate with the specified nib file.
    func registerSupplementaryView(nib: UINib?,
                                   kind: SupplementaryViewKind,
                                   identifier: String)

    // MARK: Updating

    /// Reloads all of the data for the container view.
    func reloadData()

    /// Animates multiple insert, delete, reload, and move operations as a group.
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
}

extension CellContainerViewProtocol {

    func _dequeueAndConfigureCell(for model: ContainerViewModel, at indexPath: IndexPath) -> CellType {
        let cellModel = model[indexPath]
        let cell = self.dequeueReusableCell(identifier: cellModel.registration.reuseIdentifier, indexPath: indexPath)
        cellModel.apply(to: cell)
        return cell
    }

    func _dequeueAndConfigureSupplementaryView(for kind: SupplementaryViewKind,
                                               model: ContainerViewModel,
                                               at indexPath: IndexPath) -> SupplementaryViewType? {
        var viewModel: SupplementaryViewModel?
        switch kind {
        case .header:
            viewModel = model.sections[indexPath.section].headerViewModel

        case .footer:
            viewModel = model.sections[indexPath.section].footerViewModel
        }

        guard let headerFooter = viewModel else { return nil }

        switch headerFooter.style {
        case .customView(let registration, let config):
            let view = self.dequeueReusableSupplementaryView(kind: kind,
                                                             identifier: registration.reuseIdentifier,
                                                             indexPath: indexPath)
            // safe to un-wrap. if view model exists, there *must* be a view.
            // nil is returned above if no view model exists.
            config.apply(view!)
            return view

        case .title:
            if self is UICollectionView {
                #warning("TODO: dequeue and configure titled header/footer view")
            }

            assertionFailure("Cannot dequeue and configure title-based headers/footers for table views")
            return nil
        }
    }

    func _register(viewModel: ContainerViewModel) {
        viewModel.sections.forEach {
            self._register(sectionViewModel: $0)
        }
    }

    func _register(sectionViewModel: SectionViewModel) {
        sectionViewModel.cellViewModels.forEach {
            self._register(cellViewModel: $0)
        }

        if let header = sectionViewModel.headerViewModel {
            self._register(supplementaryViewModel: header)
        }

        if let footer = sectionViewModel.footerViewModel {
            self._register(supplementaryViewModel: footer)
        }
    }

    func _register(cellViewModel: CellViewModel) {
        let registration = cellViewModel.registration
        let identifier = registration.reuseIdentifier
        let method = registration.method

        switch method {
        case .fromClass(let cellClass):
            self.registerCell(viewClass: cellClass, identifier: identifier)

        case .fromNib:
            self.registerCell(nib: method._nib, identifier: identifier)
        }
    }

    func _register(supplementaryViewModel: SupplementaryViewModel) {
        let style = supplementaryViewModel.style
        let kind = supplementaryViewModel.kind

        switch style {
        case .customView(let registration, _):

            let identifier = registration.reuseIdentifier
            let method = registration.method

            switch method {
            case .fromClass(let viewClass):
                self.registerSupplementaryView(viewClass: viewClass, kind: kind, identifier: identifier)

            case .fromNib:
                self.registerSupplementaryView(nib: method._nib, kind: kind, identifier: identifier)
            }

        case .title:
            if self is UICollectionView {
                #warning("TODO: register custom titled header/footer view")
            }

            // otherwise, ignore.
            // cannot register title-based headers/footers for table views.
        }
    }
}
