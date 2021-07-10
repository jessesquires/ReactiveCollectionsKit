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

    func shuffled() -> Model {
        var new = Model()
        new.people = self.people.shuffled()
        new.colors = self.colors.shuffled()
        return new
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
