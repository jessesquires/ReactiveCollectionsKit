# ReactiveCollectionsKit [![CI](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml/badge.svg)](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml)

*Data-driven, declarative, reactive, diffable collections (and lists!) for iOS. A modern, fast, and flexible library for `UICollectionView` done right.*

## About

This library is the culmination of everything I learned from building and maintaining [`IGListKit`](https://github.com/instagram/iglistkit), [`ReactiveLists`](https://github.com/plangrid/reactivelists), and [`JSQDataSourcesKit`](https://github.com/jessesquires/JSQDataSourcesKit). The 4th time's a charm! 🍀

This library contains a number of improvements, optimizations, and refinements over the aforementioned libraries. I have incorporated what I think are the best ideas and architecture design elements from each of these libraries, while eschewing (or improving upon) the details that I think were not so good. Importantly, this library uses modern `UICollectionView` APIs — namely, `UICollectionViewDiffableDataSource` and `UICollectionViewCompositionalLayout`, both of which were unavailable when the previous libraries were written. This library has no third-party dependencies and is written in Swift.

### What about SwiftUI?

SwiftUI performance is still a significant issue, not to mention all the bugs, missing APIs, and lack of back-porting APIs to older OS versions. SwiftUI still does not provide a proper `UICollectionView` replacement. Yes, `Grid` exists but it is nowhere close to a replacement for `UICollectionView` and `UICollectionViewLayout`. While SwiftUI's `List` is pretty good much of the time, both `LazyVStack` and `LazyHStack` suffer from severe performance issues when you have large amounts of data.

## Main Features

|         | Main Features  |
----------|-----------------
🏛️ | Declarative, data-driven architecture with reusable components
🔐 | Immutable, uni-directional data flow
🤖 | Automatic diffing for cells, sections, and supplementary views
📝 | Automatic registration for cells and supplementary views
🔠 | Create collections with mixed data types, powered by protocols and generics
🔎 | Fine-grained control over diffing behavior for your models
🚀 | Sensible defaults via protocol extensions
🛠️ | Extendable API, customizable via protocols
📱 | Simply `UICollectionView` and `UICollectionViewDiffableDataSource` at its core
🚫 | Never call `apply(_ snapshot:)`, `reloadData()`, or `performBatchUpdates()` again
🚫 | Never call `register(_:forCellWithReuseIdentifier:)` again
🚫 | Never implement `DataSource` and `Delegate` methods again
🏎️ | All Swift and zero third-party dependencies
✅ | Fully unit tested

Notably, this library consolidates and centers on `UICollectionView`. There is **no** `UITableView` support because `UICollectionView` now has a [List Layout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout/3600951-list) that obviates the need for `UITableView` entirely.

## Getting Started

> [!TIP]
>
> Check out the extensive [example project](https://github.com/jessesquires/ReactiveCollectionsKit/tree/main/Example) included in this repo.

Here's a brief example of building a simple, static list from an array of data models.

```swift
let models = [/* array of some data models */]

// create cell view models from the data models
let cellViewModels = models.map {
    MyCellViewModel($0)
}

// create the sections with cells
let section = SectionViewModel(id: "my_section", cells: cellViewModels)

// create the collection with sections
let collectionViewModel = CollectionViewModel(sections: [section])

// create the layout
let layout = UICollectionViewCompositionalLayout.list(
    using: .init(appearance: .insetGrouped)
)

// initialize the driver with the view model and other components
let driver = CollectionViewDriver(
    view: collectionView,
    layout: layout,
    viewModel: collectionViewModel,
    emptyViewProvider: provider,
    cellEventCoordinator: coordinator
)

// the collection view is updated and animated automatically

// when the models change, generate a new view model (like above)
let updatedCollectionViewModel = CollectionViewModel(sections: [/* updated items and sections */])
driver.viewModel = updatedCollectionViewModel
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

## Notes on library architecture

Below are some high-level notes on architecture and core concepts in this library.

### Immutability and data flow

> TODO:

### Diffing

> TODO:

### Generics and type-erasure

> TODO:

## Additional Resources

- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views), Apple Dev Docs
- [Updating Collection Views Using Diffable Data Sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources), Apple Dev Docs
- [Prefetching collection view data](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching/prefetching_collection_view_data), Apple Dev Docs
- [Building High-Performance Lists and Collection Views](https://developer.apple.com/documentation/uikit/uiimage/building_high-performance_lists_and_collection_views), Apple Dev Docs
- [Make blazing fast lists and collection views](https://developer.apple.com/videos/play/wwdc2021/10252/), WWDC21
- [Advances in diffable data sources](https://developer.apple.com/videos/play/wwdc2020/10045/), WWDC20
- [Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097/), WWDC20
- [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026/), WWDC20
- [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/), WWDC20
- [Creating Lists with Collection View](https://useyourloaf.com/blog/creating-lists-with-collection-view/), Use Your Loaf
- [Getting Started with `UICollectionViewCompositionalLayout`](https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/), Lickability
- [The Case for Lists in UICollectionView](https://pspdfkit.com/blog/2020/the-case-for-lists-in-uicollectionview/), PSPDFKit Blog
- [CompositionalDiffablePlayground](https://github.com/nemecek-filip/CompositionalDiffablePlayground.ios), Filip Němeček

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
