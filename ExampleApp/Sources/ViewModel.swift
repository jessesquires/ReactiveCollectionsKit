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

enum ViewModel {

    static func makeCollectionViewModel(controller: UIViewController) -> ContainerViewModel {
        let people = Person.makePeople()

        let peopleCellViewModels = people.map { person in
            PersonCollectionCellViewModel(person: person, didSelect: {
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        let section = SectionViewModel(id: "section_0",
                                       cells: peopleCellViewModels)

        return ContainerViewModel(sections: [section])
    }

    static func makeTableViewModel(controller: UIViewController) -> ContainerViewModel {
        let people = Person.makePeople()

        let peopleCellViewModels = people.map { person in
            PersonTableCellViewModel(person: person, didSelect: {
                let personVC = PersonViewController(person: person)
                controller.navigationController?.pushViewController(personVC, animated: true)
            })
        }

        let header = PersonTableHeaderViewModel()

        let footer = PersonTableFooterViewModel()

        let section = SectionViewModel(id: "section_0",
                                       cells: peopleCellViewModels,
                                       header: header,
                                       footer: footer)

        return ContainerViewModel(sections: [section])
    }
}

// swiftlint:enable trailing_closure
