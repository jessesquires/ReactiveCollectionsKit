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

/// Describes all information needed to register a view for reuse with a `UICollectionView`.
public struct ViewRegistration: Hashable {
    public let reuseIdentifier: String

    public let viewType: ViewRegistrationViewType

    public let method: ViewRegistrationMethod

    public init(
        reuseIdentifier: String,
        viewType: ViewRegistrationViewType,
        method: ViewRegistrationMethod
    ) {
        self.reuseIdentifier = reuseIdentifier
        self.viewType = viewType
        self.method = method
    }

    public func dequeueViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        switch self.viewType {
        case .cell:
            return self._dequeueCellFor(collectionView: collectionView, at: indexPath)

        case .supplementary(let kind):
            return self._dequeueSupplementaryViewFor(kind: kind, collectionView: collectionView, at: indexPath)
        }
    }

    private func _dequeueCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
    }

    private func _dequeueSupplementaryViewFor(kind: String, collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        )
    }

    public func registerWith(collectionView: UICollectionView) {
        switch self.viewType {
        case .cell:
            self._registerCellWith(collectionView: collectionView)

        case .supplementary(let kind):
            self._registerSupplementaryView(kind: kind, with: collectionView)
        }
    }

    private func _registerCellWith(collectionView: UICollectionView) {
        switch self.method {
        case .viewClass(let anyClass):
            collectionView.register(anyClass, forCellWithReuseIdentifier: self.reuseIdentifier)

        case .nib(let name, let bundle):
            let nib = UINib(nibName: name, bundle: bundle)
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        }
    }

    private func _registerSupplementaryView(kind: String, with collectionView: UICollectionView) {
        switch self.method {
        case .viewClass(let anyClass):
            collectionView.register(
                anyClass,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: self.reuseIdentifier
            )

        case .nib(let name, let bundle):
            let nib = UINib(nibName: name, bundle: bundle)
            collectionView.register(
                nib,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: self.reuseIdentifier
            )
        }
    }
}

extension ViewRegistration {
    public init(reuseIdentifier: String, cellClass: AnyClass) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .cell,
            method: .viewClass(cellClass)
        )
    }

    public init(reuseIdentifier: String, cellNibName: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .cell,
            method: .nib(name: cellNibName, bundle: nil)
        )
    }

    public init(reuseIdentifier: String, supplementaryViewClass: AnyClass, kind: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .supplementary(kind: kind),
            method: .viewClass(supplementaryViewClass)
        )
    }

    public init(reuseIdentifier: String, supplementaryViewNibName: String, kind: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .supplementary(kind: kind),
            method: .nib(name: supplementaryViewNibName, bundle: nil)
        )
    }
}
