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

public typealias SupplementaryViewKind = String

/// Defines a view model that describes and configures a supplementary view in a collection.
public protocol SupplementaryViewModel: DiffableViewModel, ViewRegistrationProvider {
    associatedtype ViewType: UICollectionReusableView

    func configure(view: ViewType)
}

extension SupplementaryViewModel {
    public var viewClass: AnyClass { ViewType.self }

    public var reuseIdentifier: String { "\(Self.self)" }

    var _kind: SupplementaryViewKind {
        switch self.registration.viewType {
        case .cell:
            preconditionFailure("Expected ViewRegistrationViewType.supplementary. Found cell.")

        case .supplementary(let kind):
            kind
        }
    }

    var _isHeader: Bool { self._kind == UICollectionView.elementKindSectionHeader }

    var _isFooter: Bool { self._kind == UICollectionView.elementKindSectionFooter }

    public var anyViewModel: AnySupplementaryViewModel {
        AnySupplementaryViewModel(self)
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

    public func configure(view: ViewType) {
        self._configure(view)
    }

    // MARK: Private

    private let _viewModel: AnyHashable
    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _configure: (ViewType) -> Void

    // MARK: Init

    public init<T: SupplementaryViewModel>(_ viewModel: T) {
        self._viewModel = viewModel
        self._id = viewModel.id
        self._registration = viewModel.registration
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
