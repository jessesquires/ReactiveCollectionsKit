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
import ReactiveCollectionsKit

struct Model {
    private(set) var people = PersonModel.makePeople()

    private(set) var colors = ColorModel.makeColors()

    mutating func shuffle() {
        self.people.shuffle()
        self.colors.shuffle()
    }

    mutating func delete(id: UniqueIdentifier) {
        if let index = self.people.firstIndex(where: { $0.id == id }) {
            self.people.remove(at: index)
        }
        if let index = self.colors.firstIndex(where: { $0.id == id }) {
            self.colors.remove(at: index)
        }
    }

    mutating func toggleFavorite(id: UniqueIdentifier) {
        if let index = self.people.firstIndex(where: { $0.id == id }) {
            self.people[index].isFavorite.toggle()
        }
        if let index = self.colors.firstIndex(where: { $0.id == id }) {
            self.colors[index].isFavorite.toggle()
        }
    }
}

extension Model: CustomDebugStringConvertible {
    var debugDescription: String {
        let peopleNames = self.people.map(\.name).joined(separator: "\n\t")
        let colorNames = self.colors.map(\.name).joined(separator: "\n\t")
        return """
        People:
            \(peopleNames)

        Colors:
            \(colorNames)
        """
    }
}
