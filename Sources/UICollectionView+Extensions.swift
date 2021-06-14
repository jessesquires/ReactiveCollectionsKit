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

extension UICollectionView {
    func _dequeueAndConfigureCell(for model: CollectionViewModel, at indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = model[indexPath]
        let cell = self.dequeueReusableCell(withReuseIdentifier: cellModel.registration.reuseIdentifier, for: indexPath)
        cellModel.apply(to: cell)
        return cell
    }

    func _dequeueAndConfigureSupplementaryView(for kind: SupplementaryViewKind,
                                               model: CollectionViewModel,
                                               at indexPath: IndexPath) -> UICollectionReusableView? {
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
            let view = self.dequeueReusableSupplementaryView(ofKind: kind._collectionElementKind,
                                                             withReuseIdentifier: registration.reuseIdentifier,
                                                             for: indexPath)
            // safe to un-wrap. if view model exists, there *must* be a view.
            // nil is returned above if no view model exists.
            config.apply(view)
            return view

        case .title:
            #warning("TODO: list configuration?")
            assertionFailure("Cannot dequeue and configure title-based headers/footers for table views")
            return nil
        }
    }

    func _register(viewModel: CollectionViewModel) {
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
            self.register(cellClass, forCellWithReuseIdentifier: identifier)

        case .fromNib:
            self.register(method._nib, forCellWithReuseIdentifier: identifier)
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
                self.register(viewClass,
                              forSupplementaryViewOfKind: kind._collectionElementKind,
                              withReuseIdentifier: identifier)

            case .fromNib:
                self.register(method._nib,
                              forSupplementaryViewOfKind: kind._collectionElementKind,
                              withReuseIdentifier: identifier)
            }

        case .title:
            #warning("TODO: list configuration?")
        }
    }
}
