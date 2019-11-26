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

final class FakeTableCell: UITableViewCell { }

final class FakeTableHeaderView: UITableViewHeaderFooterView { }

final class FakeTableFooterView: UITableViewHeaderFooterView { }

final class FakeTableView: UITableView {

    var dequeueCellExpectation: XCTestExpectation?
    override func dequeueReusableCell(withIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UITableViewCell {
        self.dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    var registerCellClassExpectation: XCTestExpectation?
    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.registerCellClassExpectation?.fulfill()
        super.register(cellClass, forCellReuseIdentifier: identifier)
    }

    var registerCellNibExpectation: XCTestExpectation?
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.registerCellNibExpectation?.fulfill()
        super.register(nib, forCellReuseIdentifier: identifier)
    }

    var dequeueHeaderFooterExpectation: XCTestExpectation?
    override func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        self.dequeueHeaderFooterExpectation?.fulfill()
        return super.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    var registerHeaderFooterClassExpectation: XCTestExpectation?
    override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        self.registerHeaderFooterClassExpectation?.fulfill()
        super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    var registerHeaderFooterNibExpectation: XCTestExpectation?
    override func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        self.registerHeaderFooterNibExpectation?.fulfill()
        super.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
