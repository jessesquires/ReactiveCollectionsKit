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

enum TestReuseIdentifier: String {
    case cell
    case footerView
    case headerView
}

struct TestCellModel: CellViewModel {
    nonisolated var id: UniqueIdentifier { "\(Self.self)" }

    func configure(cell: FakeCollectionCell) { }
}
