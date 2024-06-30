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
import XCTest

final class FakeCollectionCell: UICollectionViewCell { }

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

    var dequeueSupplementaryViewExpectation: XCTestExpectation?
    override func dequeueReusableSupplementaryView(ofKind elementKind: String,
                                                   withReuseIdentifier identifier: String,
                                                   for indexPath: IndexPath) -> UICollectionReusableView {
        self.dequeueSupplementaryViewExpectation?.fulfillAndLog()
        return super.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                      withReuseIdentifier: identifier,
                                                      for: indexPath)
    }

    var registerSupplementaryViewExpectation: XCTestExpectation?
    override func register(_ viewClass: AnyClass?,
                           forSupplementaryViewOfKind elementKind: String,
                           withReuseIdentifier identifier: String) {
        self.registerSupplementaryViewExpectation?.fulfillAndLog()
        super.register(viewClass,
                       forSupplementaryViewOfKind: elementKind,
                       withReuseIdentifier: identifier)
    }

    var registerSupplementaryNibExpectation: XCTestExpectation?
    override func register(_ nib: UINib?,
                           forSupplementaryViewOfKind kind: String,
                           withReuseIdentifier identifier: String) {
        self.registerSupplementaryNibExpectation?.fulfillAndLog()
        super.register(nib,
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: identifier)
    }
}
