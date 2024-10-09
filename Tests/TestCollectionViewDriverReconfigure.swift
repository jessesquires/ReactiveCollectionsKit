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

final class TestCollectionViewDriverReconfigure: UnitTestCase, @unchecked Sendable {

    @MainActor
    func test_reconfigure_item() async {
        var uniqueCell = MyStaticCellViewModel(name: "initial")
        uniqueCell.expectation = self.expectation(field: .configure, id: uniqueCell.name)

        let numberCells = (1...5).map { _ in
            var viewModel = FakeNumberCellViewModel()
            viewModel.expectationConfigureCell = self.expectation(field: .configure, id: viewModel.id)
            return viewModel
        }

        let section1 = SectionViewModel(id: "one", cells: numberCells)
        let section2 = SectionViewModel(id: "two", cells: [uniqueCell])
        let section3 = self.fakeSectionViewModel(id: "three")
        let model = CollectionViewModel(id: "id", sections: [section1, section2, section3])

        let viewController = FakeCollectionViewController()
        let driver = CollectionViewDriver(view: viewController.collectionView, viewModel: model)
        self.simulateAppearance(viewController: viewController)
        self.waitForExpectations()

        // Update one cell to be reconfigured
        uniqueCell = MyStaticCellViewModel(name: "updated")
        uniqueCell.expectation = self.expectation(field: .configure, id: uniqueCell.name)
        let updatedSection = SectionViewModel(id: "two", cells: [uniqueCell])
        let updatedModel = CollectionViewModel(id: "id", sections: [section1, updatedSection])
        await driver.update(viewModel: updatedModel)
        self.waitForExpectations()

        self.keepDriverAlive(driver)
    }

    @MainActor
    func test_reconfigure_header_footer() {
        let viewController = FakeCollectionViewController()
        viewController.collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.fakeLayout(addSupplementaryViews: false),
            animated: false
        )

        let driver = CollectionViewDriver(view: viewController.collectionView, options: .test())

        // Initial header and footer
        var header = FakeHeaderViewModel()
        header.expectationConfigureView = self.expectation(field: .configure, id: "initial_header")
        var footer = FakeFooterViewModel()
        footer.expectationConfigureView = self.expectation(field: .configure, id: "initial_footer")
        let cells = [FakeNumberCellViewModel()]
        let section = SectionViewModel(id: "id", cells: cells, header: header, footer: footer)
        let model = CollectionViewModel(id: "id", sections: [section])

        driver.update(viewModel: model)
        self.simulateAppearance(viewController: viewController)
        self.waitForExpectations()

        // Update header and footer to be reconfigured
        var updatedHeader = FakeHeaderViewModel()
        updatedHeader.expectationConfigureView = self.expectation(field: .configure, id: "updated_header")
        var updatedFooter = FakeFooterViewModel()
        updatedFooter.expectationConfigureView = self.expectation(field: .configure, id: "updated_footer")
        let updatedSection = SectionViewModel(id: "id", cells: cells, header: updatedHeader, footer: updatedFooter)
        let updatedModel = CollectionViewModel(id: "id", sections: [updatedSection])

        driver.update(viewModel: updatedModel)
        self.waitForExpectations()

        self.keepDriverAlive(driver)
    }
}

private struct MyStaticCellViewModel: CellViewModel {
    let id: UniqueIdentifier = "MyCellViewModel"
    let name: String

    var expectation: XCTestExpectation?
    func configure(cell: FakeCollectionCell) {
        expectation?.fulfillAndLog()
    }

    static func == (left: Self, right: Self) -> Bool {
        left.name == right.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
