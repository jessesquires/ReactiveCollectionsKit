# ReactiveCollectionsKit [![CI](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml/badge.svg)](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml)

*Data-driven, declarative, reactive, diffable collections (and lists!) for iOS. A modern, fast, and flexible library for `UICollectionView` done right.*

## About

This library is the culmination of everything I learned from building and maintaining [`IGListKit`][0], [`ReactiveLists`][1], and [`JSQDataSourcesKit`][2]. The 4th time's a charm! 🍀

This library contains a number of improvements, optimizations, and refinements over the aforementioned libraries. I have incorporated what I think are the best ideas and architecture design elements from each of these libraries, while eschewing (or improving upon) the details that I think were not so good. Importantly, this library uses modern `UICollectionView` APIs — namely, `UICollectionViewDiffableDataSource` and `UICollectionViewCompositionalLayout`, both of which were unavailable when the previous libraries were written. This library has no third-party dependencies and is written in Swift.

### What about SwiftUI?

SwiftUI performance is still a significant issue, not to mention all the bugs, missing APIs, and lack of back-porting APIs to older OS versions. SwiftUI still does not provide a proper `UICollectionView` replacement. Yes, `Grid` exists but it is nowhere close to a replacement for `UICollectionView` and `UICollectionViewLayout`. While SwiftUI's `List` is pretty good much of the time, both `LazyVStack` and `LazyHStack` suffer from severe performance issues when you have large amounts of data.

## Main Features

|  | Main Features |
---|----------------
🏛️ | Declarative, data-driven architecture with reusable components
🔐 | Immutable, uni-directional data flow
🤖 | Automatic diffing for cells, sections, and supplementary views
🎟️ | Automatic registration and dequeuing for cells and supplementary views
📏 | Automatic self-sizing cells and supplementary views
🔠 | Create collections with mixed data types, powered by protocols and generics
🔎 | Fine-grained control over diffing behavior for your models
🚀 | Sensible defaults via protocol extensions
🛠️ | Extendable API, customizable via protocols
📱 | Simply `UICollectionView` and `UICollectionViewDiffableDataSource` at its core
🙅 | Never call `apply(_ snapshot:)`, `reloadData()`, or `performBatchUpdates()` again
🙅 | Never call `register(_:forCellWithReuseIdentifier:)` or `dequeueReusableCell(withReuseIdentifier:for:)` again
🙅 | Never implement `DataSource` and `Delegate` methods again
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

Below are some high-level notes on architecture and core concepts in this library, along with comparisons to the other libraries I have worked on —  [`IGListKit`][0], [`ReactiveLists`][1], and [`JSQDataSourcesKit`][2].

### Overview

The main shortcomings of [`IGListKit`][0] are the lack of expressivity in Objective-C's type system, some boilerplate set up, mutability, and using sections as the base/fundamental component. While it is general-purpose, much of the design is informed by what we needed specifically at Instagram. What `IGListKit` got right was diffing — in fact, we pioneered that entire idea. The APIs in `UIKit` _came after_ we released `IGListKit` and were heavily influenced by what we did.

The main shortcomings of [`ReactiveLists`][1] are that it uses older `UIKit` APIs and a custom, third-party diffing library. It maintains entirely separate infrastructure for tables and collections, which duplicates a lot of functionality. There's a `TableViewModel` and a `CollectionViewModel`, etc. for use with `UITableView` and `UICollectionView`. It is also a bit incomplete as we only implemented what we needed at PlanGrid. It pre-dates the modern collection view APIs for diffing and list layouts. What `ReactiveLists` got right was a declarative API, using a cell as the base/fundamental component, and uni-directional data flow.

[`JSQDataSourcesKit`][2] in some sense was always kind of experimental and academic. It doesn't do any diffing and also has separate infrastructure for tables and collections, as it pre-dated those modern collection view APIs. It was primarily concerned with constructing type-safe data sources that eliminated the boilerplate associated with `UITableViewDataSource` and `UICollectionViewDataSource`. Ultimately, the generics were too unwieldy. See my post, _[Deprecating JSQDataSourcesKit](https://www.jessesquires.com/blog/2020/04/14/deprecating-jsqdatasourceskit/)_, for more details. What `JSQDataSourcesKit` got right was the idea of using generics to provide type-safety, though it was not executed well.

All of this experience and knowledge has culminated in me writing this library, `ReactiveCollectionsKit`, which aims to _keep_ all the good ideas and designs from the libraries above, while also addressing their shortcomings. I wrote or maintained all of them, so hopefully I'll get it right this time! :)

### Immutability and uni-directional data flow

Details that [`ReactiveLists`][1] got right are immutability, a declarative API, and uni-directional data flow. With `ReactiveLists`, you declaratively define your entire collection view model and regenerate it whenever your underlying data model changes.

Meanwhile, [`IGListKit`][0] is very imperative and mutable. With `IGListKit`, after you hook-up your `IGListAdapter` and `IGListSectionController` objects, you update sections in-place. `IGListKit` encourages immutable data models but this is not enforceable in Objective-C, nor is it enforced in the API. `IGListKit` does have uni-directional data flow in some sense, but you provide your data imperatively via `IGListAdapterDataSource` which also requires you to manually manage a mapping of your data model objects to their corresponding `IGListSectionController` objects.

`ReactiveCollectionsKit` improves upon the approach taken by both `ReactiveLists` and `IGListKit`, and removes or consolidates the boilerplate required by `IGListKit`.

The [`CellViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/CellViewModel.html) is the fundamental or "atomic" component in the library. It encapsulates all data, configuration, interaction, and registration for a single cell. This is similar to `ReactiveLists`. In `IGListKit`, this component corresponds to `IGListSectionController`. A shortcoming of `IGListKit` is that the "atomic" component is an entire section of multiple items — a section could have a single item and this scenario it more closely resembles `CellViewModel`.

The [`CollectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/CollectionViewModel.html) defines the entire structure of the collection. It is an immutable representation of your collection of data models, which can be anything. The "driver" terminology is borrowed from `ReactiveLists`. This component is more or less equivalent to the `IGListAdapter` found in `IGListKit`.

Together, these two core components allow for uni-directional data flow. The general workflow is: (1) fetch or update your data models, (2) from that data, generate your `CellViewModel` objects and complete `CollectionViewModel`, (3) set the view model on the `CollectionViewDriver`, which will then perform a diff using the previously set model and update the `UICollectionView`.

### Diffing: identity and equality

Understanding diffing requires understanding two core concepts: **identity** and **equality**. In `ReactiveCollectionsKit`, these concepts are modeled by `DiffableViewModel`.

```swift
typealias UniqueIdentifier = AnyHashable

protocol DiffableViewModel: Identifiable, Hashable {
    var id: UniqueIdentifier { get }
}
```

**Identity** concerns itself with **permanently** and **uniquely** identifying a single instance of an object. An identity _never_ changes. Identity answers the question _"who is this?"_ For example, a passport encapsulates the concept of _identity_ for a person. A passport permanently and uniquely identifies and corresponds to a single person. Identity is captured by the `Identifiable` protocol and the corresponding `id` property.

**Equality** concerns itself with **ephemeral** _traits_ or _properties_ of a single unique object that _change_ over time. Equality answers the question _"which of these objects with the same `id` is the most up-to-date?"_ For example, a person is a unique entity, but they can change their hairstyle, they can wear different clothes, and can generally change any aspect of their physical appearance. While we can uniquely identify a person using their passport on any day, their physical appearance changes day-to-day or year-to-year. Equality is captured by the `Hashable` (and `Equatable`) protocol and the corresponding `==` and `hash(into:)` functions.

Using this example, consider constructing a list of people to display in a collection. We can uniquely identify each person (using `id`) in the collection. This allows us to determine (1) if they are present, (2) their precise position, (3) if they have been delete/moved/added. Next, we can determine when they have changed (using `==`). This allows us to determine when a unique person in the collection needs to be reloaded or refreshed.

Both [`IGListKit`][0] and [`ReactiveLists`][1] got this correct, but their implementations are more cumbersome and manual. `ReactiveCollectionsKit` improves upon both of these implementations with the `DiffableViewModel` protocol above (and Swift's type system). Identifiers can be _anything_ that is hashable, but typically this is only a `String`. Because Swift can automatically synthesize conformances to `Hashable`, most clients will get all of that functionality for free. If you need to optimize your `Hashable` implementation, you can manually implement the protocol:

```swift
func hash(into hasher: inout Hasher)

static func == (left: Self, right: Self) -> Bool
```

> [!IMPORTANT]
>
> The collection view APIs in UIKit **do not handle _equality_**. [`UICollectionViewDiffableDataSource`](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource) **only concerns itself with _identity_** — it handles the structure (inserts/deletes/moves) for you, but you must handle reload (or reconfigure) for item property changes. (See: [Tyler Fox](https://mobile.twitter.com/smileyborg/status/1402164265897758720).)
>
> This is one of the primary motivations for this library, and the reason why a library like this is necessary. When using `UICollectionViewDiffableDataSource`, you must track property changes for all items in the collection on your own, and then reload/reconfigure accordingly.

### The `CellViewModel` protocol

As mentioned above, [`CellViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/CellViewModel.html) is the "base" or "atomic" component of this library. This is "where the magic happens." A `CellViewModel` declaratively defines everything needed for a cell to be displayed, diffed, and interacted with. It should encapsulate all data it needs to do configure a cell and handle interaction events. The model also includes a declarative definition of how to register the cell with the collection view for reuse.

The `CellViewModel` protocol inherits from [`DiffableViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/DiffableViewModel.html) and [`ViewRegistrationProvider`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/ViewRegistrationProvider.html) to accomplish these tasks. This allows for automatic and customizable diffing and automatic view registration. Because of Swift's default implementations via protocol extensions, you can get a lot of default behavior for free. As mentioned above, you can get `Equatable` and `Hashable` conformances for free via synthesized definitions from the compiler. For `ViewRegistrationProvider`, you get a default class-based registration for free. This is functionality similar to `ReactiveLists`. `IGListKit` also offers automatic registration, but it is very implicit.

Essentially, all data source and delegate methods from the collection view are forwarded to each instance of `CellViewModel`.

For headers, footers, and supplementary views there is a similar [`SupplementaryViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Protocols/SupplementaryViewModel.html).

### Generics and type-erasure

[`IGListKit`][0], despite some Swift refinements, suffers from the lack of expressivity in Objective-C's type system. [`ReactiveLists`][1] handles this better, but it pre-dates the modern improvements to Swift's generics and existentials. In `ReactiveLists`, configuring a cell requires force-casting from `UITableViewCell` or `UICollectionViewCell` to the specific cell type for the view model. In `ReactiveCollectionsKit`, this is solved with generics and associated types.

```swift
protocol CellViewModel: DiffableViewModel, ViewRegistrationProvider {
    associatedtype CellType: UICollectionViewCell

    func configure(cell: CellType)

    // other members...
}
```

Using generics was something that [`JSQDataSourcesKit`][2] got right, sort of. While it was nice to avoid casting view types in `JSQDataSourcesKit`, the generics proliferated all the way to the data source layer, which resulted in poor API ergonomics and extreme difficulty regarding displaying mixed data types. You also could not mix supplementary view types. You could work around the limitations for cells with an `enum`, but it was not very practical.

To mitigate those shortcomings experienced in `JSQDataSourcesKit` and handle the heterogenous types downstream when constructing a section (via [`SectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/SectionViewModel.html)), you must erase the cell types. This functionality is provided via an extension method on `CellViewModel`.

```swift
func eraseToAnyViewModel() -> AnyCellViewModel
```

`SupplementaryViewModel` follows a similar design, allowing you to mix types for supplementary views as well.

In practice, this means when using mixed data types, you'll need to eventually convert your specific cell view models to `AnyCellViewModel`.

```swift
let people = [Person]()

let cellViewModels = people.map {
    PersonCellViewModel($0).eraseToAnyViewModel()
}
```

However, because of Swift, you'll notice that [`SectionViewModel`](https://jessesquires.github.io/ReactiveCollectionsKit/Structs/SectionViewModel.html) provides a number of convenience initializers using generics. In the scenarios where you _do not have mixed data types_, the generic initializers allow you ignore this implementation detail and handle the type-erasure for you.

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

<!-- links -->

[0]:https://github.com/instagram/iglistkit
[1]:https://github.com/plangrid/reactivelists
[2]:https://github.com/jessesquires/JSQDataSourcesKit
