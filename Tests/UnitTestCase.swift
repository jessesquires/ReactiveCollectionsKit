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

@testable import ReactiveCollectionsKit
import XCTest

enum ReuseIdentifier: String {
    case cell
    case headerView
    case footerView
}

struct TestCellModel: CellViewModel {
    let cellClassType: AnyClass

    var registration: ReusableViewRegistration { ReusableViewRegistration(classType: self.cellClassType) }

    let didSelect = CellActions.DidSelectNoOperation

    func size<V: UIView & CellContainerViewProtocol>(in containerView: V) -> CGSize { .zero }

    func apply(to cell: Self.CellType) { }
}

struct TestHeaderFooterModel: SupplementaryViewModel {
    let title: String
    let kind: SupplementaryViewKind

    var style: SupplementaryViewStyle { .title(self.title) }
}

class UnitTestCase: XCTestCase {

    private static let frame = CGRect(x: 0, y: 0, width: 320, height: 600)

    let collectionView = FakeCollectionView(frame: frame,
                                            collectionViewLayout: FakeCollectionLayout())

    let tableView = FakeTableView(frame: frame, style: .plain)

    override func setUp() {
        super.setUp()

        self.collectionView.layoutSubviews()
        self.collectionView.reloadData()

        self.tableView.layoutSubviews()
        self.tableView.reloadData()
    }
}
