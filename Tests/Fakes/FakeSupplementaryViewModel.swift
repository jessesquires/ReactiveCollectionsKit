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
import XCTest

struct FakeSupplementaryViewModel: SupplementaryViewModel {
    static let kind = "FakeKind"

    let title = String.random

    nonisolated var id: UniqueIdentifier { "\(Self.self)" }

    let registration = ViewRegistration(
        reuseIdentifier: "view",
        supplementaryViewClass: FakeSupplementaryView.self,
        kind: Self.kind
    )

    var expectationConfigureView: XCTestExpectation?
    func configure(view: FakeSupplementaryView) {
        self.expectationConfigureView?.fulfillAndLog()
    }

    nonisolated static func == (left: Self, right: Self) -> Bool {
        left.title == right.title
    }

    nonisolated func hash(into hasher: inout Hasher) {
        self.title.hash(into: &hasher)
    }
}

final class FakeSupplementaryView: UICollectionViewCell { }

struct FakeHeaderViewModel: SupplementaryHeaderViewModel {
    nonisolated var id: UniqueIdentifier { "\(Self.self)" }

    func configure(view: FakeCollectionHeaderView) { }
}

final class FakeCollectionHeaderView: UICollectionReusableView { }

struct FakeFooterViewModel: SupplementaryFooterViewModel {
    nonisolated var id: UniqueIdentifier { "\(Self.self)" }

    func configure(view: FakeCollectionFooterView) { }
}

final class FakeCollectionFooterView: UICollectionReusableView { }
