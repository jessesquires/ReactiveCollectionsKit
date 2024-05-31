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

enum FakeReuseIdentifier: String {
    case cell
    case footerView
    case headerView
}

struct FakeCellViewModel: CellViewModel {
    nonisolated var id: UniqueIdentifier { "\(Self.self)" }

    func configure(cell: FakeCollectionCell) { }
}
