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

    /// The data source for this container view.
    associatedtype DataSource

    /// The delegate for this container view.
    associatedtype Delegate

    // MARK: Properties

    var dataSource: DataSource? { get set }

    var delegate: Delegate? { get set }

    // MARK: Cells

    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType

    func registerCellClass(_ cellClass: AnyClass?, identifier: String)

    func registerCellNib(_ cellNib: UINib?, identifier: String)

    // MARK: Supplementary views

    func dequeueReusableSupplementaryViewFor(kind: SupplementaryViewKind,
                                             identifier: String,
                                             indexPath: IndexPath) -> SupplementaryViewType?

    func registerSupplementaryViewClass(_ supplementaryClass: AnyClass?,
                                        kind: SupplementaryViewKind,
                                        identifier: String)

    func registerSupplementaryViewNib(_ supplementaryNib: UINib?,
                                      kind: SupplementaryViewKind,
                                      identifier: String)

    // MARK: Updating

    func reloadData()

    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
}

extension CellContainerViewProtocol {

    func dequeueAndConfigureCell(for model: ContainerViewModel, at indexPath: IndexPath) -> CellType {
        let cellModel = model[indexPath]
        let cell = self.dequeueReusableCellFor(identifier: cellModel.registration.reuseIdentifier, indexPath: indexPath)
        cellModel.apply(to: cell)
        return cell
    }

    func dequeueAndConfigureSupplementaryView(for kind: SupplementaryViewKind,
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
        case .customView(let registration):
            return self.dequeueReusableSupplementaryViewFor(kind: kind,
                                                            identifier: registration.reuseIdentifier,
                                                            indexPath: indexPath)

        case .title:
            #warning("nil works for table views only. fix for collections?")
            return nil
        }
    }

    func register(viewModel: ContainerViewModel) {
        viewModel.sections.forEach {
            self.register(sectionViewModel: $0)
        }
    }

    func register(sectionViewModel: SectionViewModel) {
        sectionViewModel.cellViewModels.forEach {
            self.register(cellViewModel: $0)
        }

        if let header = sectionViewModel.headerViewModel {
            self.register(supplementaryViewModel: header)
        }

        if let footer = sectionViewModel.footerViewModel {
            self.register(supplementaryViewModel: footer)
        }
    }

    func register(cellViewModel: CellViewModel) {
        let registration = cellViewModel.registration
        let identifier = registration.reuseIdentifier
        let method = registration.method

        switch method {
        case .fromClass(let cellClass):
            self.registerCellClass(cellClass, identifier: identifier)

        case .fromNib:
            self.registerCellNib(method.nib, identifier: identifier)
        }
    }

    func register(supplementaryViewModel: SupplementaryViewModel) {
        let style = supplementaryViewModel.style
        let kind = supplementaryViewModel.kind

        switch style {
        case .customView(let registration):

            let identifier = registration.reuseIdentifier
            let method = registration.method

            switch method {
            case .fromClass(let viewClass):
                self.registerSupplementaryViewClass(viewClass, kind: kind, identifier: identifier)

            case .fromNib:
                self.registerSupplementaryViewNib(method.nib, kind: kind, identifier: identifier)
            }

        case .title:
            // ignore. cannot register title-based views.
            break
        }
    }
}
