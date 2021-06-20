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

public typealias SupplementaryViewKind = String

/// Defines a view model that describes and configures a supplementary view in the collection view.
public protocol SupplementaryViewModel: DiffableViewModel {
    associatedtype ViewType: UICollectionReusableView

    static var kind: SupplementaryViewKind { get }

    var reuseIdentifier: String { get }

    var nib: UINib? { get }

    func registerWith(collectionView: UICollectionView)

    func configure(view: ViewType)
}

extension SupplementaryViewModel {
    public var viewClass: AnyClass { ViewType.self }

    public var kind: SupplementaryViewKind { Self.kind }

    public var reuseIdentifier: String { "\(Self.self)" }

    public var nib: UINib? { nil }

    public func registerWith(collectionView: UICollectionView) {
        if let nib = self.nib {
            collectionView.register(
                nib,
                forSupplementaryViewOfKind: Self.kind,
                withReuseIdentifier: self.reuseIdentifier
            )
        } else {
            collectionView.register(
                self.viewClass,
                forSupplementaryViewOfKind: Self.kind,
                withReuseIdentifier: self.reuseIdentifier
            )
        }
    }

    public func dequeueAndConfigureViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> ViewType {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: Self.kind,
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as! ViewType
        self.configure(view: view)
        return view
    }
}

public struct AnySupplementaryViewModel: SupplementaryViewModel {
    // MARK: DiffableViewModel

    public var id: UniqueIdentifier { self._id }

    // MARK: SupplementaryViewModel

    public typealias ViewType = UICollectionReusableView

    public static var kind: SupplementaryViewKind { self._kind }

    public var reuseIdentifier: String { self._reuseIdentifier }

    public var nib: UINib? { self._nib }

    public func registerWith(collectionView: UICollectionView) {
        self._register(collectionView)
    }

    public func configure(view: ViewType) {
        self._configure(view)
    }

    // MARK: Private

    private let _id: UniqueIdentifier
    private static var _kind = ""
    private let _reuseIdentifier: String
    private let _nib: UINib?
    private let _register: (UICollectionView) -> Void
    private let _configure: (ViewType) -> Void

    // MARK: Init

    public init<T: SupplementaryViewModel>(_ viewModel: T) {
        self._id = viewModel.id
        Self._kind = T.kind
        self._reuseIdentifier = viewModel.reuseIdentifier
        self._nib = viewModel.nib
        self._register = { collectionView in
            viewModel.registerWith(collectionView: collectionView)
        }
        self._configure = { view in
            precondition(view is T.ViewType, "View must be of type \(T.ViewType.self). Found \(view.self)")
            viewModel.configure(view: view as! T.ViewType)
        }
    }
}
