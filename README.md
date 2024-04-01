# ReactiveCollectionsKit [![CI](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml/badge.svg)](https://github.com/jessesquires/ReactiveCollectionsKit/actions/workflows/ci.yml)

### ⚠️ Work-In-Progress ⚠️

*Declarative, reactive*

## About

> TODO: explain about

## Usage

Here's an example of buliding a simple, static list from an array of data models.

```swift
final class MyViewController: UICollectionViewController {

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
            controller: self
        )

        // the collection is updated and animated automatically

        // later, you can update the model like so:
        let updatedCollectionViewModel = CollectionViewModel(sections: [/* updated items and sections */])
        self.driver.viewModel = updatedCollectionViewModel
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
