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

struct Model {
    private(set) var people = PersonModel.makePeople()

    private(set) var colors = ColorModel.makeColors()

    mutating func shuffle() {
        self.people.shuffle()
        self.colors.shuffle()
    }

    mutating func deleteModelAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.people.remove(at: indexPath.row)

        case 1:
            self.colors.remove(at: indexPath.row)

        default:
            fatalError("invalid indexPath: \(indexPath)")
        }
    }

    mutating func toggleFavoriteAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.people[indexPath.row].isFavorite.toggle()

        case 1:
            self.colors[indexPath.row].isFavorite.toggle()

        default:
            fatalError("invalid indexPath: \(indexPath)")
        }
    }
}

extension Model: CustomDebugStringConvertible {
    var debugDescription: String {
        let peopleNames = self.people.map { $0.name }.joined(separator: "\n\t")
        let colorNames = self.colors.map { $0.name }.joined(separator: "\n\t")
        return """
        People:
            \(peopleNames)

        Colors:
            \(colorNames)
        """
    }
}
