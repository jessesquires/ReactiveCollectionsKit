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
import XCTest

final class FakeCollectionCell: UICollectionViewCell { }

final class FakeCollectionHeaderView: UICollectionReusableView { }

final class FakeCollectionFooterView: UICollectionReusableView { }

final class FakeCollectionLayout: UICollectionViewFlowLayout { }

final class FakeCollectionView: UICollectionView {

    var dequeueCellExpectation: XCTestExpectation?
    override func dequeueReusableCell(withReuseIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UICollectionViewCell {
        self.dequeueCellExpectation?.fulfillAndLog()
        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    var registerCellClassExpectation: XCTestExpectation?
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.registerCellClassExpectation?.fulfillAndLog()
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    var registerCellNibExpectation: XCTestExpectation?
    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.registerCellNibExpectation?.fulfillAndLog()
        super.register(nib, forCellWithReuseIdentifier: identifier)
    }

    var dequeueHeaderFooterExpectation: XCTestExpectation?
    override func dequeueReusableSupplementaryView(ofKind elementKind: String,
                                                   withReuseIdentifier identifier: String,
                                                   for indexPath: IndexPath) -> UICollectionReusableView {
        self.dequeueHeaderFooterExpectation?.fulfillAndLog()
        return super.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                      withReuseIdentifier: identifier,
                                                      for: indexPath)
    }

    var registerHeaderFooterClassExpectation: XCTestExpectation?
    override func register(_ viewClass: AnyClass?,
                           forSupplementaryViewOfKind elementKind: String,
                           withReuseIdentifier identifier: String) {
        self.registerHeaderFooterClassExpectation?.fulfillAndLog()
        super.register(viewClass,
                       forSupplementaryViewOfKind: elementKind,
                       withReuseIdentifier: identifier)
    }

    var registerHeaderFooterNibExpectation: XCTestExpectation?
    override func register(_ nib: UINib?,
                           forSupplementaryViewOfKind kind: String,
                           withReuseIdentifier identifier: String) {
        self.registerHeaderFooterNibExpectation?.fulfillAndLog()
        super.register(nib,
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: identifier)
    }
}

final class FakeCollectionViewController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
