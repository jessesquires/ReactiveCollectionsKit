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
import UIKit

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
    typealias ItemAction = (UniqueIdentifier) -> Void

    static func create(
        model: Model,
        style: ViewModelStyle,
        favoriteAction: @escaping ItemAction,
        deleteAction: @escaping ItemAction) -> CollectionViewModel {

        // MARK: People Section

        let peopleCellViewModels: [AnyCellViewModel] = model.people.map {
            let menuConfig = UIContextMenuConfiguration.configFor(
                itemId: $0.id,
                favoriteAction: favoriteAction,
                deleteAction: deleteAction
            )

            switch style {
            case .grid:
                return PersonCellViewModelGrid(
                    person: $0,
                    contextMenuConfiguration: menuConfig
                ).anyViewModel

            case .list:
                return PersonCellViewModelList(
                    person: $0,
                    contextMenuConfiguration: menuConfig
                ).anyViewModel
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
            let menuConfig = UIContextMenuConfiguration.configFor(
                itemId: $0.id,
                favoriteAction: favoriteAction,
                deleteAction: deleteAction
            )

            switch style {
            case .grid:
                return ColorCellViewModelGrid(
                    color: $0,
                    contextMenuConfiguration: menuConfig
                ).anyViewModel

            case .list:
                return ColorCellViewModelList(
                    color: $0,
                    contextMenuConfiguration: menuConfig
                ).anyViewModel
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
