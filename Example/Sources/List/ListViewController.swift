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

import Combine
import ReactiveCollectionsKit
import UIKit

final class ListViewController: ExampleViewController, CellEventCoordinator {

    lazy var driver = CollectionViewDriver(
        view: self.collectionView,
        layout: self.makeLayout(),
        emptyViewProvider: sharedEmptyViewProvider,
        cellEventCoordinator: self
    ) { [unowned self] driver in
        print("list did update!")
        print(driver.viewModel)
    }

    override var model: Model {
        didSet {
            // Every time the model updates, regenerate and set the view model
            self.driver.viewModel = self.makeViewModel()
        }
    }

    private var cancellables = [AnyCancellable]()

    // MARK: CellEventCoordinator

    // In this example, the cell view models handle cell selection and navigation themselves.

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.driver.viewModel = self.makeViewModel()

        self.driver.$viewModel
            .sink { _ in
                print("did publish view model update")
            }
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary
            configuration.footerMode = .supplementary
            return NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
        }
    }

    private func makeViewModel() -> CollectionViewModel {
        // Create People Section
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

            return PersonCellViewModelList(
                person: $0,
                contextMenuConfiguration: menuConfig
            ).eraseToAnyViewModel()
        }
        let peopleHeader = HeaderViewModel(title: "People", style: .small)
        let peopleFooter = FooterViewModel(text: "\(self.model.people.count) people")
        let peopleSection = SectionViewModel(
            id: "section_people_list",
            cells: peopleCellViewModels,
            header: peopleHeader,
            footer: peopleFooter
        )

        // Create Color Section
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
            return ColorCellViewModelList(
                color: $0,
                contextMenuConfiguration: menuConfig
            ).eraseToAnyViewModel()
        }
        let colorHeader = HeaderViewModel(title: "Colors", style: .small)
        let colorFooter = FooterViewModel(text: "\(self.model.colors.count) colors")
        let colorSection = SectionViewModel(
            id: "section_colors_list",
            cells: colorCellViewModels,
            header: colorHeader,
            footer: colorFooter
        )

        // Create final view model
        return CollectionViewModel(id: "list_view", sections: [peopleSection, colorSection])
    }
}
