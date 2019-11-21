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

// swiftlint:disable trailing_closure unused_closure_parameter

enum ViewModel { }

extension ViewModel {
    static func makeCollectionViewModel(model: Model) -> ContainerViewModel {

        let peopleCellViewModels = model.people.map { person in
            PersonCollectionCellViewModel(person: person, didSelect: { indexPath, container, controller in
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels)

        let colorCellViewModels = model.colors.map { ColorCollectionCellViewModel(color: $0) }
        let colorSection = SectionViewModel(id: "section_1_colors",
                                            cells: colorCellViewModels)

        return ContainerViewModel(sections: [peopleSection, colorSection])
    }
}

extension ViewModel {
    static func makeTableViewModel(model: Model) -> ContainerViewModel {

        let peopleCellViewModels = model.people.map { person in
            PersonTableCellViewModel(person: person, didSelect: { indexPath, container, controller in
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels,
                                             header: PersonTableHeaderViewModel(),
                                             footer: PersonTableFooterViewModel())

        let colorCellViewModels = model.colors.map { ColorTableCellViewModel(color: $0) }
        let colorSection = SectionViewModel(id: "section_1_colors",
                                            cells: colorCellViewModels,
                                            header: ColorTableHeaderViewModel())

        return ContainerViewModel(sections: [peopleSection, colorSection])
    }
}

// swiftlint:enable trailing_closure unused_closure_parameter
