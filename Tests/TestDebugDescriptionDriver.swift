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

final class TestDebugDescriptionDriver: XCTestCase {

    private static let addressPattern = "0x[0-9a-fA-F]{8,12}" // 0x7b7c00003800 or 0x1509a2270
    private static let framePattern = #"\(\d+ \d+; \d+ \d+\)"# // (0 0; 402 874)
    private static let contentOffsetPattern = #"\{\d+, \d+\}"# // {0, 0}
    private static let contentSizePattern = #"\{\d+, \d+\}"# // {0, 0}
    private static let adjustedContentInsetPattern = #"\{\d+, \d+, \d+, \d+\}"# // {0, 0, 0, 0}

    // swiftlint:disable:next line_length
    private let viewPattern = "<ReactiveCollectionsKitTests\\.FakeCollectionView: \(addressPattern); baseClass = UICollectionView; frame = \(framePattern); clipsToBounds = YES; gestureRecognizers = <NSArray: \(addressPattern)>; backgroundColor = <UIDynamicSystemColor: \(addressPattern); name = systemBackgroundColor>; layer = <CALayer: \(addressPattern)>; contentOffset: \(contentOffsetPattern); contentSize: \(contentSizePattern); adjustedContentInset: \(adjustedContentInsetPattern); layout: <ReactiveCollectionsKitTests\\.FakeCollectionLayout: \(addressPattern)>; dataSource: <ReactiveCollectionsKit\\.DiffableDataSource: \(addressPattern)>>"

    private func assertEqualRegex(
        string: String,
        pattern: String,
        numMatches: Int = 1,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let regex = try NSRegularExpression(pattern: pattern)
        let count = regex.numberOfMatches(in: string, range: NSRange(string.startIndex..., in: string))
        XCTAssertEqual(count, numMatches, message(), file: file, line: line)
    }

    @MainActor
    func test_empty() throws {
        let viewController = FakeCollectionViewController()
        let viewModel = self.fakeCollectionViewModel(
            id: "viewModel_1",
            numSections: 0,
            numCells: 0
        )
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            viewModel: viewModel
        )

        let pattern =
            """
            CollectionViewDriver \\{
              options:
                CollectionViewDriverOptions \\{
                  diffOnBackgroundQueue: false
                  reloadDataOnReplacingViewModel: false
                \\}
              viewModel:
                CollectionViewModel \\{
                  id: viewModel_1
                  sections: none
                  registrations: none
                  isEmpty: true
                \\}
              emptyViewProvider: nil
              cellEventCoordinator: nil
              scrollViewDelegate: nil
              flowLayoutDelegate: nil
              view: \(viewPattern)
            \\}

            """

        try self.assertEqualRegex(string: driver.debugDescription, pattern: pattern)
    }

    @MainActor
    func test_viewModel() throws {
        let viewController = FakeCollectionViewController()
        let viewModel = self.fakeCollectionViewModel(
            id: "viewModel_2",
            numSections: 1,
            numCells: 1,
            includeHeader: true,
            includeFooter: true,
            includeSupplementaryViews: true
        )
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            viewModel: viewModel
        )

        let pattern =
            """
            CollectionViewDriver \\{
              options:
                CollectionViewDriverOptions \\{
                  diffOnBackgroundQueue: false
                  reloadDataOnReplacingViewModel: false
                \\}
              viewModel:
                CollectionViewModel \\{
                  id: viewModel_2
                  sections:
                    \\[0\\]:
                      id: section_0
                      header: Header \\(FakeHeaderViewModel\\)
                      footer: Footer \\(FakeFooterViewModel\\)
                      cells:
                        \\[0\\]: cell_0_0 \\(FakeNumberCellViewModel\\)
                      supplementary views:
                        \\[0\\]: view_0_0 \\(FakeSupplementaryViewModel\\)
                      isEmpty: false
                  registrations:
                    - FakeFooterViewModel \\(UICollectionElementKindSectionFooter\\)
                    - FakeHeaderViewModel \\(UICollectionElementKindSectionHeader\\)
                    - FakeNumberCellViewModel \\(cell\\)
                    - FakeSupplementaryViewModel \\(FakeKind\\)
                  isEmpty: false
                \\}
              emptyViewProvider: nil
              cellEventCoordinator: nil
              scrollViewDelegate: nil
              flowLayoutDelegate: nil
              view: \(viewPattern)
            \\}

            """

        try self.assertEqualRegex(string: driver.debugDescription, pattern: pattern)
    }

    @MainActor
    func test_delegate() throws {
        let viewController = FakeCollectionViewController()
        let viewModel = self.fakeCollectionViewModel(
            id: "viewModel_3",
            numSections: 0,
            numCells: 0
        )
        let emptyViewProvider = EmptyViewProvider {
            UIView()
        }
        let cellEventCoordinator = FakeCellEventCoordinator()
        let flowLayoutDelegate = FakeFlowLayoutDelegate()
        let driver = CollectionViewDriver(
            view: viewController.collectionView,
            viewModel: viewModel,
            emptyViewProvider: emptyViewProvider,
            cellEventCoordinator: cellEventCoordinator
        )
        driver.scrollViewDelegate = flowLayoutDelegate
        driver.flowLayoutDelegate = flowLayoutDelegate

        let pattern =
            """
            CollectionViewDriver \\{
              options:
                CollectionViewDriverOptions \\{
                  diffOnBackgroundQueue: false
                  reloadDataOnReplacingViewModel: false
                \\}
              viewModel:
                CollectionViewModel \\{
                  id: viewModel_3
                  sections: none
                  registrations: none
                  isEmpty: true
                \\}
              emptyViewProvider: EmptyViewProvider\\(viewBuilder: \\(Function\\)\\)
              cellEventCoordinator: ReactiveCollectionsKitTests\\.FakeCellEventCoordinator
              scrollViewDelegate: <ReactiveCollectionsKitTests\\.FakeFlowLayoutDelegate: \(Self.addressPattern)>
              flowLayoutDelegate: <ReactiveCollectionsKitTests\\.FakeFlowLayoutDelegate: \(Self.addressPattern)>
              view: \(viewPattern)
            \\}

            """

        try self.assertEqualRegex(string: driver.debugDescription, pattern: pattern)
    }
}
