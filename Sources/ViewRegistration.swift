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

public enum ViewRegistrationType: Equatable, Hashable {
    case cell
    case supplementary(kind: String)
}

public struct ViewRegistration {
    let viewClass: AnyClass

    let reuseIdentifier: String

    let nibName: String?

    let nibBundle: Bundle?

    let type: ViewRegistrationType

    public var nib: UINib? {
        if let name = self.nibName {
            return UINib(nibName: name, bundle: self.nibBundle)
        }
        return nil
    }

    public func dequeueViewFor(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        switch self.type {
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
        switch self.type {
        case .cell:
            self._registerCellWith(collectionView: collectionView)

        case .supplementary(let kind):
            self._registerSupplementaryView(kind: kind, with: collectionView)
        }
    }

    private func _registerCellWith(collectionView: UICollectionView) {
        if let nib = self.nib {
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        } else {
            collectionView.register(self.viewClass, forCellWithReuseIdentifier: self.reuseIdentifier)
        }
    }

    private func _registerSupplementaryView(kind: String, with collectionView: UICollectionView) {
        if let nib = self.nib {
            collectionView.register(
                nib,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: self.reuseIdentifier
            )
        } else {
            collectionView.register(
                self.viewClass,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: self.reuseIdentifier
            )
        }
    }
}

extension ViewRegistration: Equatable, Hashable {
    private var _viewClassName: String {
        "\(self.viewClass)"
    }

    public static func == (left: ViewRegistration, right: ViewRegistration) -> Bool {
        left._viewClassName == right._viewClassName
        && left.reuseIdentifier == right.reuseIdentifier
        && left.nibName == right.nibName
        && left.nibBundle == right.nibBundle
        && left.type == right.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._viewClassName)
        hasher.combine(self.reuseIdentifier)
        hasher.combine(self.nibName)
        hasher.combine(self.nibBundle)
        hasher.combine(self.type)
    }
}
