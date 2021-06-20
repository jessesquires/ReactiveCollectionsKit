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

public protocol SupplementaryHeaderViewModel: SupplementaryViewModel {
    static var kind: SupplementaryViewKind { get }
}

extension SupplementaryHeaderViewModel {
    public static var kind: SupplementaryViewKind {
        UICollectionView.elementKindSectionHeader
    }

    public var kind: SupplementaryViewKind {
        Self.kind
    }
}
