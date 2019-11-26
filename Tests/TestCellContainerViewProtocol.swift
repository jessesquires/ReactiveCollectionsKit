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

/// Testing conformance to CellContainerViewProtocol
/// Set expectations and call the protocol methods.
/// Ensure UIKit methods are called.
final class TestCellContainerViewProtocol: UnitTestCase {

    // MARK: Collection

    func test_collectionView_conforms_to_CellContainerViewProtocol_register_cell_class() {
        self.collectionView.registerCellClassExpectation = self.expectation()

        self.collectionView.registerCell(viewClass: FakeCollectionCell.self,
                                         identifier: ReuseIdentifier.cell.rawValue)

        self.waitForExpectations()
    }

    func test_collectionView_conforms_to_CellContainerViewProtocol_register_cell_nib() {
        self.collectionView.registerCellNibExpectation = self.expectation()

        self.collectionView.registerCell(nib: nil, identifier: ReuseIdentifier.cell.rawValue)

        self.waitForExpectations()
    }

    func test_collectionView_conforms_to_CellContainerViewProtocol_dequeue_cell() {
        self.collectionView.dequeueCellExpectation = self.expectation()

        self.collectionView.registerCell(viewClass: FakeCollectionCell.self,
                                         identifier: ReuseIdentifier.cell.rawValue)

        _ = self.collectionView.dequeueReusableCell(identifier: ReuseIdentifier.cell.rawValue,
                                                    indexPath: IndexPath())

        self.waitForExpectations()
    }

    func test_collectionView_conforms_to_CellContainerViewProtocol_register_headerFooter_class() {
        self.collectionView.registerHeaderFooterClassExpectation = self.expectation()

        self.collectionView.registerSupplementaryView(viewClass: FakeCollectionHeaderView.self,
                                                      kind: SupplementaryViewKind.header,
                                                      identifier: ReuseIdentifier.headerView.rawValue)

        self.waitForExpectations()
    }

    func test_collectionView_conforms_to_CellContainerViewProtocol_register_headerFooter_nib() {
        self.collectionView.registerHeaderFooterNibExpectation = self.expectation()

        self.collectionView.registerSupplementaryView(nib: nil,
                                                      kind: SupplementaryViewKind.footer,
                                                      identifier: ReuseIdentifier.footerView.rawValue)

        self.waitForExpectations()
    }

    func test_collectionView_conforms_to_CellContainerViewProtocol_dequeue_headerFooter() {
        self.collectionView.dequeueHeaderFooterExpectation = self.expectation()

        self.collectionView.registerSupplementaryView(viewClass: FakeCollectionHeaderView.self,
                                                      kind: SupplementaryViewKind.header,
                                                      identifier: ReuseIdentifier.headerView.rawValue)

        _ = self.collectionView.dequeueReusableSupplementaryView(kind: SupplementaryViewKind.header,
                                                                 identifier: ReuseIdentifier.headerView.rawValue,
                                                                 indexPath: IndexPath())

        self.waitForExpectations()
    }

    // MARK: Table

    func test_tableView_conforms_to_CellContainerViewProtocol_register_cell_class() {
        self.tableView.registerCellClassExpectation = self.expectation()

        self.tableView.registerCell(viewClass: FakeTableCell.self,
                                    identifier: ReuseIdentifier.cell.rawValue)

        self.waitForExpectations()
    }

    func test_tableView_conforms_to_CellContainerViewProtocol_register_cell_nib() {
        self.tableView.registerCellNibExpectation = self.expectation()

        self.tableView.registerCell(nib: nil, identifier: ReuseIdentifier.cell.rawValue)

        self.waitForExpectations()
    }

    func test_tableView_conforms_to_CellContainerViewProtocol_dequeue_cell() {
        self.tableView.dequeueCellExpectation = self.expectation()

        self.tableView.registerCell(viewClass: FakeTableCell.self,
                                    identifier: ReuseIdentifier.cell.rawValue)

        _ = self.tableView.dequeueReusableCell(identifier: ReuseIdentifier.cell.rawValue,
                                               indexPath: IndexPath())

        self.waitForExpectations()
    }

    func test_tableView_conforms_to_CellContainerViewProtocol_register_headerFooter_class() {
        self.tableView.registerHeaderFooterClassExpectation = self.expectation()

        self.tableView.registerSupplementaryView(viewClass: FakeTableHeaderView.self,
                                                 kind: SupplementaryViewKind.header,
                                                 identifier: ReuseIdentifier.headerView.rawValue)

        self.waitForExpectations()
    }

    func test_tableView_conforms_to_CellContainerViewProtocol_register_headerFooter_nib() {
        self.tableView.registerHeaderFooterNibExpectation = self.expectation()

        self.tableView.registerSupplementaryView(nib: nil,
                                                 kind: SupplementaryViewKind.footer,
                                                 identifier: ReuseIdentifier.footerView.rawValue)

        self.waitForExpectations()
    }

    func test_tableView_conforms_to_CellContainerViewProtocol_dequeue_headerFooter() {
        self.tableView.dequeueHeaderFooterExpectation = self.expectation()

        self.tableView.registerSupplementaryView(viewClass: FakeTableHeaderView.self,
                                                 kind: SupplementaryViewKind.header,
                                                 identifier: ReuseIdentifier.headerView.rawValue)

        _ = self.tableView.dequeueReusableSupplementaryView(kind: SupplementaryViewKind.header,
                                                            identifier: ReuseIdentifier.headerView.rawValue,
                                                            indexPath: IndexPath())

        self.waitForExpectations()
    }
}
