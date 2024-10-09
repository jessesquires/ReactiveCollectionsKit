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

final class FakeSupplementaryNibView: UICollectionReusableView {
    @IBOutlet var label: UILabel!
}

struct FakeSupplementaryNibViewModel: SupplementaryViewModel {
    static let kind = "FakeKindWithNib"

    let id: UniqueIdentifier = String.random

    var registration: ViewRegistration {
        ViewRegistration(
            reuseIdentifier: self.reuseIdentifier,
            viewType: .supplementary(kind: Self.kind),
            method: .nib(
                name: "FakeSupplementaryNib",
                bundle: .testBundle
            )
        )
    }

    var expectationConfigureView: XCTestExpectation?
    func configure(view: FakeSupplementaryNibView) {
        self.expectationConfigureView?.fulfillAndLog()
    }

    static func == (left: Self, right: Self) -> Bool {
        left.id == right.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
