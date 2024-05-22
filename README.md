# ReactiveCollectionsKit [![CI](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml/badge.svg)](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml)

*Data-driven, declarative, reactive, diffable collections (and lists!) for iOS. A thoughtful and flexible wrapper for UICollectionView done right.*

## Project Status: initial release coming soon! ⚠️

This project is close to finished for an initial release. I started this a few years back, then got busy with other things.
I am now returning to the project to get the initial release complete. In any case, what's here now is worth sharing.

## About

This library is the culmination of everything I learned from building and maintaining [IGListKit](https://github.com/instagram/iglistkit), [ReactiveLists](https://github.com/plangrid/reactivelists), and [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit). The 4th time's a charm! 🍀

Improvements over the libraries above include:

- All Swift and zero third-party dependencies
- Generic view models to represent and configure cells
- Mix multiple data types
- Automatic registration for cells and supplementary views
- Automatic diffing for items and sections
- Simply `UICollectionView`, `UICollectionViewCompositionalLayout`, and `UICollectionViewDiffableDataSource` at its core.
- No `UITableView`. Only `UICollectionView`, which now has a [List Layout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout/3600951-list).

### What about SwiftUI?

SwiftUI performance is still a significant issue, not to mention all the bugs and missing APIs. SwiftUI still does not provide a proper `UICollectionView` replacement. (Yes, `Grid` exists but it is nowhere close to a replacement for `UICollectionView` and `UICollectionViewLayout`.) While SwiftUI's `List` is pretty good, both `LazyVStack` and `LazyHStack` suffer from severe performance issues when you have large amounts of data.

## Main Features

> TODO
>
> ⚠️ Work-In-Progress ⚠️

## Usage

> [!TIP]
>
> Check out the extensive example project included in this repo.

Here's an example of building a simple, static list from an array of data models.

```swift
class MyViewController: UICollectionViewController, CellEventCoordinator {

    var driver: CollectionViewDriver!

    override func viewDidLoad() {
        super.viewDidLoad()

        let models = [/* array of some data models */]

        // create cell view models from the data models
        let cellViewModels = models.map {
            MyCellViewModel($0)
        }

        // create your sections, and add cells
        let section = SectionViewModel(id: "my_section", cells: cellViewModels)

        // create the collection with all the sections
        let collectionViewModel = CollectionViewModel(sections: [section])

        // create your collection view layout
        let layout = UICollectionViewCompositionalLayout.list(
            using: .init(appearance: .insetGrouped)
        )

        // initialize the driver will all of the above
        self.driver = CollectionViewDriver(
            view: self.collectionView,
            layout: layout,
            viewModel: collectionViewModel,
            cellEventCoordinator: self
        )

        // the collection is updated and animated automatically

        // later, you can update the model like so:
        let updatedCollectionViewModel = CollectionViewModel(sections: [/* updated items and sections */])
        self.driver.viewModel = updatedCollectionViewModel
    }

    // MARK: CellEventCoordinator

    func didSelectCell(viewModel: any CellViewModel) {
        // TODO: handle cell selection events
    }
}
```

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- [SwiftLint](https://github.com/realm/SwiftLint)

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/jessesquires/ReactiveCollectionsKit.git", from: "0.1.0")
]
```

Alternatively, you can add the package [directly via Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Documentation

You can read the [documentation here](https://jessesquires.github.io/ReactiveCollectionsKit). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

## Additional Resources

- [Advances in diffable data sources](https://developer.apple.com/videos/play/wwdc2020/10045/), WWDC20
- [Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097/), WWDC20
- [Building High-Performance Lists and Collection Views](https://developer.apple.com/documentation/uikit/uiimage/building_high-performance_lists_and_collection_views), Apple Sample Code
- [Creating Lists with Collection View](https://useyourloaf.com/blog/creating-lists-with-collection-view/), Use Your Loaf
- [Getting Started with `UICollectionViewCompositionalLayout`](https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/), Lickability
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views), Apple Sample Code
- [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026/), WWDC20
- [Make blazing fast lists and collection views](https://developer.apple.com/videos/play/wwdc2021/10252/), WWDC21
- [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/), WWDC20
- [The Case for Lists in UICollectionView](https://pspdfkit.com/blog/2020/the-case-for-lists-in-uicollectionview/), PSPDFKit Blog

## Contributing

Interested in making contributions to this project? Please review the guides below.

- [Contributing Guidelines](https://github.com/jessesquires/.github/blob/master/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/jessesquires/.github/blob/master/CODE_OF_CONDUCT.md)
- [Support and Help](https://github.com/jessesquires/.github/blob/master/SUPPORT.md)
- [Security Policy](https://github.com/jessesquires/.github/blob/master/SECURITY.md)

Also, consider [sponsoring this project](https://www.jessesquires.com/sponsor/) or [buying my apps](https://www.hexedbits.com)! ✌️

## Credits

Created and maintained by [**Jesse Squires**](https://www.jessesquires.com).

## License

Released under the MIT License. See `LICENSE` for details.

> **Copyright &copy; 2019-present Jesse Squires.**
