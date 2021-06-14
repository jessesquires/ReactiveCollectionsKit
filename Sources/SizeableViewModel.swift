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

public protocol SizeableViewModel {

    func height<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGFloat

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize
}

extension SizeableViewModel {
    public func height<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGFloat {
        if containerView is UICollectionView {
            return 150
        }
        preconditionFailure("Unknown container view type: \(containerView)")
    }

    public func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize {
        CGSize(width: containerView.frame.size.width, height: self.height(in: containerView))
    }
}
