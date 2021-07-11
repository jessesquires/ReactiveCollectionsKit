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

enum ViewModelStyle: String {
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
                return GridPersonCellViewModel(person: $0).anyViewModel

            case .list:
                return ListPersonCellViewModel(person: $0).anyViewModel
            }
        }

        let peopleHeader = HeaderViewModel(title: "People", style: style.headerStyle)

        let peopleFooter = FooterViewModel(text: "\(model.people.count) people")

        let peopleFavoriteBadges: [FavoriteBadgeViewModel] = model.people.compactMap {
            if style == .list {
                return nil
            }
            return FavoriteBadgeViewModel(isHidden: !$0.isFavorite, id: $0.name + "_badge")
        }

        let peopleSection = SectionViewModel(id: "section_0_people_\(style.rawValue)",
                                             cells: peopleCellViewModels,
                                             header: peopleHeader,
                                             footer: peopleFooter,
                                             supplementaryViews: peopleFavoriteBadges)

        // MARK: Color Section

        let colorCellViewModels: [AnyCellViewModel] = model.colors.map {
            switch style {
            case .grid:
                return GridColorCellViewModel(color: $0).anyViewModel

            case .list:
                return ListColorCellViewModel(color: $0).anyViewModel
            }
        }

        let colorHeader = HeaderViewModel(title: "Colors", style: style.headerStyle)

        let colorFooter = FooterViewModel(text: "\(model.colors.count) colors")

        let colorFavoriteBadges: [FavoriteBadgeViewModel] = model.colors.compactMap {
            if style == .list {
                return nil
            }
            return FavoriteBadgeViewModel(isHidden: !$0.isFavorite, id: $0.name + "_badge")
        }

        let colorSection = SectionViewModel(id: "section_1_colors_\(style.rawValue)",
                                            cells: colorCellViewModels,
                                            header: colorHeader,
                                            footer: colorFooter,
                                            supplementaryViews: colorFavoriteBadges)

        return CollectionViewModel(sections: [peopleSection, colorSection])
    }
}
