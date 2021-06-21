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

enum ViewModelStyle {
    case grid
    case list

    var headerStyle: HeaderViewStyle {
        switch self {
        case .grid:
            return .large

        case .list:
            return .small
        }
    }
}

enum ViewModel {
    static func createGrid(from model: Model) -> CollectionViewModel {
        self.create(model: model, style: .grid)
    }

    static func createList(from model: Model) -> CollectionViewModel {
        self.create(model: model, style: .list)
    }

    private static func create(model: Model, style: ViewModelStyle) -> CollectionViewModel {

        // MARK: People Section

        let peopleCellViewModels: [AnyCellViewModel] = model.people.map {
            switch style {
            case .grid:
                return AnyCellViewModel(GridPersonCellViewModel(person: $0))

            case .list:
                return AnyCellViewModel(ListPersonCellViewModel(person: $0))
            }
        }

        let peopleHeader = AnySupplementaryViewModel(HeaderViewModel(title: "People", style: style.headerStyle))

        let peopleFooter = AnySupplementaryViewModel(FooterViewModel(text: "Footer text for the people section"))

        let peopleFavoriteBadges = model.people
            .map { FavoriteBadgeViewModel(isHidden: false, id: $0.name + " badge") }
            .map { AnySupplementaryViewModel($0) }

        var peopleSupplementaryViews = [peopleHeader, peopleFooter]
        if style == .grid {
            peopleSupplementaryViews += peopleFavoriteBadges
        }

        let peopleSection = SectionViewModel(id: "section_0_people",
                                             anyCells: peopleCellViewModels,
                                             anySupplementaryViews: peopleSupplementaryViews)

        // MARK: Color Section

        let colorCellViewModels: [AnyCellViewModel] = model.colors.map {
            switch style {
            case .grid:
                return AnyCellViewModel(GridColorCellViewModel(color: $0))

            case .list:
                return AnyCellViewModel(ListColorCellViewModel(color: $0))
            }
        }
        let colorHeader = AnySupplementaryViewModel(HeaderViewModel(title: "Colors", style: style.headerStyle))

        let colorFooter = AnySupplementaryViewModel(FooterViewModel(text: "Footer text for the color section"))

        let colorFavoriteBadges = model.colors
            .map { FavoriteBadgeViewModel(isHidden: false, id: $0.name + " badge") }
            .map { AnySupplementaryViewModel($0) }

        var colorSupplementaryViews = [colorHeader, colorFooter]
        if style == .grid {
            colorSupplementaryViews += colorFavoriteBadges
        }

        let colorSection = SectionViewModel(id: "section_1_colors",
                                            anyCells: colorCellViewModels,
                                            anySupplementaryViews: colorSupplementaryViews)

        return CollectionViewModel(sections: [peopleSection, colorSection])
    }
}
