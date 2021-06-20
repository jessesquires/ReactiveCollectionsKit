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

public protocol SupplementaryFooterViewModel: SupplementaryViewModel {
    static var kind: SupplementaryViewKind { get }
}

extension SupplementaryFooterViewModel {
    public static var kind: SupplementaryViewKind {
        UICollectionView.elementKindSectionFooter
    }

    public var kind: SupplementaryViewKind {
        Self.kind
    }
}
