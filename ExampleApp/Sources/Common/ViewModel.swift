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

// swiftlint:disable trailing_closure

enum ViewModel { }

extension ViewModel {
    static func makeCollectionViewModel(controller: UIViewController, shuffled: Bool = false) -> ContainerViewModel {
        let people = Person.makePeople()

        var peopleCellViewModels = people.map { person in
            PersonCollectionCellViewModel(person: person, didSelect: {
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        if shuffled {
            peopleCellViewModels.shuffle()
        }

        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels)

        let colors = ColorModel.makeColors()
        let colorCellViewModels = colors.map { ColorCollectionCellViewModel(color: $0) }
        let colorSection = SectionViewModel(id: "section_1_colors",
                                            cells: colorCellViewModels)

        return ContainerViewModel(sections: [peopleSection, colorSection])
    }
}

extension ViewModel {
    static func makeTableViewModel(controller: UIViewController, shuffled: Bool = false) -> ContainerViewModel {
        let people = Person.makePeople()

        var peopleCellViewModels = people.map { person in
            PersonTableCellViewModel(person: person, didSelect: {
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        if shuffled {
            peopleCellViewModels.shuffle()
        }

        let peopleSection = SectionViewModel(id: "section_0_people",
                                             cells: peopleCellViewModels,
                                             header: PersonTableHeaderViewModel(),
                                             footer: PersonTableFooterViewModel())

        let colors = ColorModel.makeColors()
        let colorCellViewModels = colors.map { ColorTableCellViewModel(color: $0) }
        let colorSection = SectionViewModel(id: "section_1_colors",
                                            cells: colorCellViewModels,
                                            header: ColorTableHeaderViewModel())

        return ContainerViewModel(sections: [peopleSection, colorSection])
    }
}

// swiftlint:enable trailing_closure
