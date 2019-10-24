//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit
import DiffableCollectionsKit

enum ViewModel {

    static func makeCollectionViewModel() -> ContainerViewModel {
        let people = Person.makePeople()

        let peopleCellViewModels = people.map { PersonCollectionCellViewModel(person: $0) }

        let section = SectionViewModel(cells: peopleCellViewModels)

        return ContainerViewModel(sections: [section])
    }

    static func makeTableViewModel() -> ContainerViewModel {
        let people = Person.makePeople()

        let peopleCellViewModels = people.map { PersonTableCellViewModel(person: $0) }

        let section = SectionViewModel(cells: peopleCellViewModels)

        return ContainerViewModel(sections: [section])
    }
}

