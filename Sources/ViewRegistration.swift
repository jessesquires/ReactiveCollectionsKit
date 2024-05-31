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
@MainActor
public struct ViewRegistration: Hashable {
    /// The view reuse identifier.
    public let reuseIdentifier: String

    /// The type of view to register.
    public let viewType: ViewRegistrationViewType

    /// The view registration method.
    public let method: ViewRegistrationMethod

    /// Initializes a `ViewRegistration`.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The view reuse identifier.
    ///   - viewType: The type of view to register.
    ///   - method: The view registration method.
    public init(
        reuseIdentifier: String,
        viewType: ViewRegistrationViewType,
        method: ViewRegistrationMethod
    ) {
        self.reuseIdentifier = reuseIdentifier
        self.viewType = viewType
        self.method = method
    }

    // MARK: Dequeuing Views

    func dequeueViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
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

    // MARK: Registering Views

    func registerWith(collectionView: UICollectionView) {
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

/// Initializes a `ViewRegistration`.
///
/// - Parameters:
///   - reuseIdentifier: The view reuse identifier.
///   - viewType: The type of view to register.
///   - method: The view registration method.
extension ViewRegistration {

    /// Convenience initializer for a class-based cell.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The cell reuse identifier.
    ///   - cellClass: The cell class.
    public init(reuseIdentifier: String, cellClass: AnyClass) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .cell,
            method: .viewClass(cellClass)
        )
    }

    /// Convenience initializer for a nib-based cell in the main bundle.
    ///
    /// - Parameters:
    ///   - reuseIdentifier:  The cell reuse identifier.
    ///   - cellNibName: The nib name for the cell.
    public init(reuseIdentifier: String, cellNibName: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .cell,
            method: .nib(name: cellNibName, bundle: nil)
        )
    }

    /// Convenience initializer for a class-based supplementary view.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The view reuse identifier.
    ///   - supplementaryViewClass: The view class.
    ///   - kind: The supplementary view kind.
    public init(reuseIdentifier: String, supplementaryViewClass: AnyClass, kind: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .supplementary(kind: kind),
            method: .viewClass(supplementaryViewClass)
        )
    }

    /// Convenience initializer for a nib-based supplementary view in the main bundle.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The view reuse identifier.
    ///   - supplementaryViewNibName: The nib name for the view.
    ///   - kind: The supplementary view kind.
    public init(reuseIdentifier: String, supplementaryViewNibName: String, kind: String) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            viewType: .supplementary(kind: kind),
            method: .nib(name: supplementaryViewNibName, bundle: nil)
        )
    }
}
