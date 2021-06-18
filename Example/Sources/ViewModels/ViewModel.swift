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

import ReactiveCollectionsKit
import UIKit

func makeCollectionViewModel(from model: Model) -> CollectionViewModel {
    let peopleCellViewModels = model.people.map { person in
        PersonCellViewModel(person: person) { _, _, controller in
            let personVC = PersonViewController(person: person)
            controller.navigationController?.pushViewController(personVC, animated: true)
        }
    }

    let anyPeopleModels = peopleCellViewModels.map { $0.toAnyViewModel() }
    let peopleSection = SectionViewModel(id: "section_0_people",
                                         cells: anyPeopleModels)

    let colorCellViewModels = model.colors.map { ColorCellViewModel(color: $0) }
    let anyColorModels = colorCellViewModels.map { $0.toAnyViewModel() }
    let colorSection = SectionViewModel(id: "section_1_colors",
                                        cells: anyColorModels)

    return CollectionViewModel(sections: [peopleSection, colorSection])
}
