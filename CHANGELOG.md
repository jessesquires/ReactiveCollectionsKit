# Changelog

The changelog for `ReactiveCollectionsKit`. Also see [the releases on GitHub](https://github.com/jessesquires/ReactiveCollectionsKit/releases).

NEXT
-----

- Improve debug descriptions (i.e., `CustomDebugStringConvertible`) for various types. ([@nuomi1](https://github.com/nuomi1), [#139](https://github.com/jessesquires/ReactiveCollectionsKit/pull/139))
- Implement (optional) debug logging for view model updates. You can now provide a logger for debugging purposes by setting `CollectionViewDriver.logger`. The library provides a default implementation via `RCKLogger.shared`. ([@nuomi1](https://github.com/nuomi1), [#141](https://github.com/jessesquires/ReactiveCollectionsKit/pull/141))
- Upgrade to Xcode 26. ([@jessesquires](https://github.com/jessesquires), [#153](https://github.com/jessesquires/ReactiveCollectionsKit/pull/153))

0.1.8
-----

- Allow setting a `UICollectionViewDelegateFlowLayout` object to receive flow layout events from the collection view. ([@jessesquires](https://github.com/jessesquires), [#134](https://github.com/jessesquires/ReactiveCollectionsKit/pull/134))
- Swift Concurrency improvements:
    - `@MainActor` annotations have been removed from most top-level types and protocols, instead opting to apply `@MainActor` to individual members only where necessary. ([@jessesquires](https://github.com/jessesquires), [#135](https://github.com/jessesquires/ReactiveCollectionsKit/pull/135))
    - `DiffableViewModel` is now marked as `Sendable`. This means `Sendable` also applies to `CellViewModel`, `SupplementaryViewModel`, `SectionViewModel`, and `CollectionViewModel`. ([@jessesquires](https://github.com/jessesquires), [#137](https://github.com/jessesquires/ReactiveCollectionsKit/pull/137))
- Various performance improvements. Notably, when configuring `CollectionViewDriver` to perform diffing on a background queue via `CollectionViewDriverOptions.diffOnBackgroundQueue`, more operations are now performed in the background that were previously running on the main thread. ([@jessesquires](https://github.com/jessesquires), [#136](https://github.com/jessesquires/ReactiveCollectionsKit/pull/136), [#137](https://github.com/jessesquires/ReactiveCollectionsKit/pull/137), [@lachenmayer](https://github.com/lachenmayer), [#138](https://github.com/jessesquires/ReactiveCollectionsKit/pull/138))

0.1.7
-----

- Upgraded to Xcode 16. ([@jessesquires](https://github.com/jessesquires), [#116](https://github.com/jessesquires/ReactiveCollectionsKit/pull/116))
- Reverted back to Swift 5 language mode because of issues in UIKit. ([@jessesquires](https://github.com/jessesquires), [#116](https://github.com/jessesquires/ReactiveCollectionsKit/pull/116))
- Applying a snapshot using `reloadData` now always occurs on the main thread. ([@jessesquires](https://github.com/jessesquires), [#116](https://github.com/jessesquires/ReactiveCollectionsKit/pull/116))
- Implemented additional selection APIs for `CellViewModel`: `shouldSelect`, `shouldDeselect`, `didDeselect()`. ([@nuomi1](https://github.com/nuomi1), [#127](https://github.com/jessesquires/ReactiveCollectionsKit/pull/127))
- Allow setting a `UIScrollViewDelegate` object to receive scroll view events from the collection view. ([@ruddfawcett](https://github.com/ruddfawcett), [#131](https://github.com/jessesquires/ReactiveCollectionsKit/pull/131), [#133](https://github.com/jessesquires/ReactiveCollectionsKit/pull/133))

0.1.6
-----

- Fixed a potential crash (in `DiffableDataSource`) when hiding a collection view before animations complete when diffing. This may have caused a crash with the message _Fatal error: Attempted to read an unowned reference but the object was already deallocated_. ([@lachenmayer](https://github.com/lachenmayer), [#125](https://github.com/jessesquires/ReactiveCollectionsKit/issues/125), [#126](https://github.com/jessesquires/ReactiveCollectionsKit/issues/126))

0.1.5
-----

- Implemented `didHighlight()` and `didUnhighlight()` APIs for `CellViewModel`. ([@nuomi1](https://github.com/nuomi1), [#123](https://github.com/jessesquires/ReactiveCollectionsKit/pull/123))

0.1.4
-----

- Implemented `willDisplay()` and `didEndDisplaying()` APIs for both `CellViewModel` and `SupplementaryViewModel`. ([@nuomi1](https://github.com/nuomi1), [#121](https://github.com/jessesquires/ReactiveCollectionsKit/pull/121))

0.1.3
-----

- Improve debug descriptions for `CollectionViewModel` and `SectionViewModel` ([@nuomi1](https://github.com/nuomi1), [#119](https://github.com/jessesquires/ReactiveCollectionsKit/pull/119), [#120](https://github.com/jessesquires/ReactiveCollectionsKit/pull/120))

0.1.2
-----

- Fixed bug when chaining multiple calls to `eraseToAnyViewModel()` for both `CellViewModel` and and `SupplementaryViewModel`. Previously, it was possible "double erase" a view model by calling `eraseToAnyViewModel()` multiple times, thus actually losing type information. Now, consecutive calls to `eraseToAnyViewModel()` have no effect. ([@nuomi1](https://github.com/nuomi1), [#117](https://github.com/jessesquires/ReactiveCollectionsKit/pull/117))

0.1.1
-----

- Documentation updates.

0.1.0
-----

Initial release. 🎉
