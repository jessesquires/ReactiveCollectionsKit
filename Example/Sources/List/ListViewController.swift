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

    var cancellables = [AnyCancellable]()

    override var model: Model {
        didSet {
            // Every time the model updates, regenerate and set the view model
            self.driver.viewModel = self.makeCollectionViewModel()
        }
    }

    // MARK: CellEventCoordinator

    func didSelectCell(viewModel: any CellViewModel) {
        print("\(#function): \(viewModel.id)")

        if let personVM = viewModel as? PersonCellViewModelList {
            let personVC = PersonViewController(person: personVM.person)
            self.navigationController?.pushViewController(personVC, animated: true)
            return
        }

        if let colorVM = viewModel as? ColorCellViewModelList {
            let colorVC = ColorViewController(color: colorVM.color)
            self.navigationController?.pushViewController(colorVC, animated: true)
            return
        }

        assertionFailure("unhandled cell selection")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.makeLayout()
        let viewModel = self.makeCollectionViewModel()

        self.driver = CollectionViewDriver(
            view: self.collectionView,
            layout: layout,
            viewModel: viewModel,
            cellEventCoordinator: self,
            animateUpdates: true
        ) { [unowned self] in
            print("list did update!")
            print(self.driver.viewModel)
        }

        self.driver.$viewModel
            .sink { _ in
                print("did publish view model update")
            }
            .store(in: &self.cancellables)

    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary
            configuration.footerMode = .supplementary

            // TODO: swipe actions need re-working. need to reference item identifier, not index path.
//            configuration.leadingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
//                let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { _, _, completion in
//                    // self.toggleFavoriteAt(indexPath: indexPath)
//                    completion(true)
//                }
//                favoriteAction.image = UIImage(systemName: "star.fill")
//                favoriteAction.backgroundColor = .systemYellow
//                return UISwipeActionsConfiguration(actions: [favoriteAction])
//            }
//
//            configuration.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
//                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
//                    // self.deleteAt(indexPath: indexPath)
//                    completion(true)
//                }
//                deleteAction.image = UIImage(systemName: "trash")
//                deleteAction.backgroundColor = .systemRed
//                return UISwipeActionsConfiguration(actions: [deleteAction])
//            }

            return NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
        }
    }

    func makeCollectionViewModel() -> CollectionViewModel {
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
            ).anyViewModel
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
            ).anyViewModel
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
        return CollectionViewModel(sections: [peopleSection, colorSection])
    }
}
