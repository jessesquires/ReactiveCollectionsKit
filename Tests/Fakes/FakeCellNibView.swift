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
@testable import ReactiveCollectionsKit
import UIKit
import XCTest

final class FakeCellNibView: UICollectionViewCell {
    @IBOutlet var label: UILabel!
}

struct FakeCellNibViewModel: CellViewModel {
    let id: UniqueIdentifier

    var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            viewType: .cell,
            method: .nib(
                name: "FakeCellNib",
                bundle: .testBundle
            )
        )
    }

    var expectationConfigureCell: XCTestExpectation?
    func configure(cell: FakeCellNibView) {
        self.expectationConfigureCell?.fulfillAndLog()
    }

    var expectationDidSelect: XCTestExpectation?
    func didSelect(with coordinator: (any CellEventCoordinator)?) {
        self.expectationDidSelect?.fulfillAndLog()
    }

    init(
        id: UniqueIdentifier = String.random,
        expectationConfigureCell: XCTestExpectation? = nil,
        expectationDidSelect: XCTestExpectation? = nil
    ) {
        self.id = id
        self.expectationConfigureCell = expectationConfigureCell
        self.expectationDidSelect = expectationDidSelect
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.id == right.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
