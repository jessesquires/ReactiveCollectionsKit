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
public protocol SupplementaryViewModel: DiffableViewModel, ViewRegistrationProvider {
    associatedtype ViewType: UICollectionReusableView

    var kind: SupplementaryViewKind { get }

    func configure(view: ViewType)
}

extension SupplementaryViewModel {
    var _isHeader: Bool { self.kind == UICollectionView.elementKindSectionHeader }

    var _isFooter: Bool { self.kind == UICollectionView.elementKindSectionFooter }

    public var anyViewModel: AnySupplementaryViewModel {
        AnySupplementaryViewModel(self)
    }

    public var viewClass: AnyClass { ViewType.self }

    public var registration: ViewRegistration {
        ViewRegistration(
            viewClass: self.viewClass,
            reuseIdentifier: self.reuseIdentifier,
            nibName: self.nibName,
            nibBundle: self.nibBundle,
            type: .supplementary(kind: self.kind)
        )
    }

    public func dequeueAndConfigureViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> ViewType {
        let view = self.registration.dequeueViewFor(collectionView: collectionView, at: indexPath) as! ViewType
        self.configure(view: view)
        return view
    }
}

public struct AnySupplementaryViewModel: SupplementaryViewModel {
    // MARK: DiffableViewModel

    public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    public var registration: ViewRegistration { self._registration }

    // MARK: SupplementaryViewModel

    public typealias ViewType = UICollectionReusableView

    public var kind: SupplementaryViewKind { self._kind }

    public func configure(view: ViewType) {
        self._configure(view)
    }

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _kind: SupplementaryViewKind
    private let _configure: (ViewType) -> Void

    // MARK: Init

    public init<T: SupplementaryViewModel>(_ viewModel: T) {
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._kind = viewModel.kind
        self._configure = { view in
            precondition(view is T.ViewType, "View must be of type \(T.ViewType.self). Found \(view.self)")
            viewModel.configure(view: view as! T.ViewType)
        }
    }
}

extension AnySupplementaryViewModel: Equatable {
    public static func == (left: AnySupplementaryViewModel, right: AnySupplementaryViewModel) -> Bool {
        left._viewModel == right._viewModel
    }
}

extension AnySupplementaryViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        self._viewModel.hash(into: &hasher)
    }
}
