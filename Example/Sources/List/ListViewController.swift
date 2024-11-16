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

    lazy var driver: CollectionViewDriver = {
        let driver = CollectionViewDriver(
            view: self.collectionView,
            options: .init(diffOnBackgroundQueue: true),
            emptyViewProvider: sharedEmptyViewProvider,
            cellEventCoordinator: self
        )
        driver.scrollViewDelegate = self
        return driver
    }()

    override var model: Model {
        didSet {
            // Every time the model updates, regenerate and set the view model
            let viewModel = self.makeViewModel()

            Task { @MainActor in
                await self.driver.update(viewModel: viewModel)
                print("list did update! async")
            }
        }
    }

    private var cancellables = [AnyCancellable]()

    // MARK: Init

    init() {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary
            configuration.footerMode = .supplementary
            return NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
        }
        super.init(collectionViewLayout: layout)
    }

    // MARK: CellEventCoordinator

    // In this example, the cell view models handle cell selection and navigation themselves.

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.driver.logger = RCKLogger.shared

        let viewModel = self.makeViewModel()
        self.driver.update(viewModel: viewModel)

        self.driver.$viewModel
            .sink { _ in
                print("did publish view model update")
            }
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private func makeViewModel() -> CollectionViewModel {
        // Create People Section
        let peopleCellViewModels = self.model.people.enumerated().map { index, person in
            let menuConfig = UIContextMenuConfiguration.configFor(
                itemId: person.id,
                favoriteAction: { [unowned self] in
                    self.toggleFavorite(id: $0)
                },
                deleteAction: { [unowned self] in
                    self.deleteItem(id: $0)
                }
            )

            let children = makeViewModel(for: person.subPeople)

            return PersonCellViewModelList(
                person: person,
                contextMenuConfiguration: menuConfig,
                children: children
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

    private func makeViewModel(for people: [PersonModel]) -> [AnyCellViewModel] {
        let children: [AnyCellViewModel] = people.map {
            PersonCellViewModelList(person: $0,
                                    contextMenuConfiguration: nil,
                                    children: makeViewModel(for: $0.subPeople)).eraseToAnyViewModel()
        }

        return children
    }
}

extension ListViewController: UIScrollViewDelegate {
    // Example of receiving scroll view events
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print(#function)
    }
}
