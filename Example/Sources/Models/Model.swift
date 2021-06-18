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
    let people: [PersonModel]
    let colors: [ColorModel]

    init(people: [PersonModel] = PersonModel.makePeople(),
         colors: [ColorModel] = ColorModel.makeColors(),
         shuffle: Bool = false) {
        self.people = shuffle ? people.shuffled() : people
        self.colors = shuffle ? colors.shuffled() : colors
    }
}
