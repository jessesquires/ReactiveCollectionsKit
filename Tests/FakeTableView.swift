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
}
