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

@testable import ExampleApp
import XCTest

final class ExampleModelTests: XCTestCase {

    func test_shuffle() {
        var model = Model()
        XCTAssertFalse(model.people.isEmpty)
        XCTAssertFalse(model.colors.isEmpty)

        let peopleCount = model.people.count
        let colorsCount = model.colors.count

        model.shuffle()
        XCTAssertEqual(model.people.count, peopleCount)
        XCTAssertEqual(model.colors.count, colorsCount)
    }

    func test_delete() {
        let personId: AnyHashable = "Noam Chomsky"
        let colorId: AnyHashable = "purple"

        var model = Model()
        XCTAssertTrue(model.people.contains(where: { $0.id == personId }))
        XCTAssertTrue(model.colors.contains(where: { $0.id == colorId }))

        model.delete(id: personId)
        XCTAssertFalse(model.people.contains(where: { $0.id == personId }))

        model.delete(id: colorId)
        XCTAssertFalse(model.colors.contains(where: { $0.id == colorId }))
    }

    func test_favorite() {
        let personId: AnyHashable = "Noam Chomsky"
        let colorId: AnyHashable = "purple"

        var model = Model()
        XCTAssertFalse(model.people.first(where: { $0.id == personId })!.isFavorite)
        XCTAssertFalse(model.colors.first(where: { $0.id == colorId })!.isFavorite)

        model.toggleFavorite(id: personId)
        XCTAssertTrue(model.people.first(where: { $0.id == personId })!.isFavorite)

        model.toggleFavorite(id: colorId)
        XCTAssertTrue(model.colors.first(where: { $0.id == colorId })!.isFavorite)
    }
}
