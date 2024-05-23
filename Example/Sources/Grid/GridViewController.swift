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

final class GridViewController: ExampleViewController, CellEventCoordinator {

    lazy var driver = CollectionViewDriver(
        view: self.collectionView,
        layout: self.makeLayout(),
        emptyViewProvider: sharedEmptyViewProvider,
        cellEventCoordinator: self
    )

    override var model: Model {
        didSet {
            // Every time the model updates, regenerate and set the view model
            self.driver.viewModel = self.makeViewModel()
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.driver.viewModel = self.makeViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.collectionView.deselectItem(at: IndexPath(item: 0, section: 0), animated: true)
    }

    // MARK: Actions

    override func reload() {
        self.driver.reloadData()
    }

    // MARK: CellEventCoordinator
    // In this example, the view controller handles cell selection and navigation.

    func didSelectCell(viewModel: any CellViewModel) {
        print("\(#function): \(viewModel.id)")

        if let personVM = viewModel as? PersonCellViewModelGrid {
            let personVC = PersonViewController(person: personVM.person)
            self.navigationController?.pushViewController(personVC, animated: true)
            return
        }

        if let colorVM = viewModel as? ColorCellViewModelGrid {
            let colorVC = ColorViewController(color: colorVM.color)
            self.navigationController?.pushViewController(colorVC, animated: true)
            return
        }

        assertionFailure("unhandled cell selection")
    }

    // MARK: Private

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let fractionalWidth = CGFloat(0.5)
        let inset = CGFloat(4)

        // Supplementary Item
        let offset = 0.15
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: offset, y: -offset))
        let dimension = NSCollectionLayoutDimension.absolute(30)
        let badgeSize = NSCollectionLayoutSize(widthDimension: dimension, heightDimension: dimension)
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: FavoriteBadgeViewModel.kind,
                                                        containerAnchor: badgeAnchor)

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(fractionalWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Headers and Footers
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(50))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: HeaderViewModel.kind,
                                                                        alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: FooterViewModel.kind,
                                                                        alignment: .bottom)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func makeViewModel() -> CollectionViewModel {
        // Create people section
        let peopleCellViewModels = self.model.people.map {
            let menuConfig = UIContextMenuConfiguration.configFor(
                itemId: $0.id,
                favoriteAction: { [unowned self] in
                    self.toggleFavorite(id: $0)
                },
                deleteAction: { [unowned self] in
                    self.deleteItem(id: $0)
                }
            )

            return PersonCellViewModelGrid(
                person: $0,
                contextMenuConfiguration: menuConfig
            ).anyViewModel
        }
        let peopleHeader = HeaderViewModel(title: "People", style: .large)
        let peopleFooter = FooterViewModel(text: "\(self.model.people.count) people")
        let peopleFavoriteBadges = self.model.people.compactMap {
            FavoriteBadgeViewModel(isHidden: !$0.isFavorite, id: $0.name + "_badge")
        }
        let peopleSection = SectionViewModel(
            id: "section_people_grid",
            cells: peopleCellViewModels,
            header: peopleHeader,
            footer: peopleFooter,
            supplementaryViews: peopleFavoriteBadges
        )

        // Create color section
        let colorCellViewModels = self.model.colors.map {
            let menuConfig = UIContextMenuConfiguration.configFor(
                itemId: $0.id,
                favoriteAction: { [unowned self] in
                    self.toggleFavorite(id: $0)
                },
                deleteAction: { [unowned self] in
                    self.deleteItem(id: $0)
                }
            )
            return ColorCellViewModelGrid(
                color: $0,
                contextMenuConfiguration: menuConfig
            ).anyViewModel
        }
        let colorHeader = HeaderViewModel(title: "Colors", style: .large)
        let colorFooter = FooterViewModel(text: "\(self.model.colors.count) colors")
        let colorFavoriteBadges = self.model.colors.compactMap {
            FavoriteBadgeViewModel(isHidden: !$0.isFavorite, id: $0.name + "_badge")
        }
        let colorSection = SectionViewModel(
            id: "section_colors_grid",
            cells: colorCellViewModels,
            header: colorHeader,
            footer: colorFooter,
            supplementaryViews: colorFavoriteBadges
        )

        // Create final view model
        return CollectionViewModel(sections: [peopleSection, colorSection])
    }
}
