# Changelog

The changelog for `ReactiveCollectionsKit`. Also see [the releases on GitHub](https://github.com/jessesquires/ReactiveCollectionsKit/releases).

NEXT
-----

- TBA

0.1.7
-----

- Upgraded to Xcode 16. ([@jessesquires](https://github.com/jessesquires), [#116](https://github.com/jessesquires/ReactiveCollectionsKit/pull/116))
- Reverted back to Swift 5 language mode because of issues in UIKit. ([@jessesquires](https://github.com/jessesquires), [#116](https://github.com/jessesquires/ReactiveCollectionsKit/pull/116))
- Implemented additional selection APIs for `CellViewModel`: `shouldSelect`, `shouldDeselect`, `didDeselect()`. ([@nuomi1](https://github.com/nuomi1), [#127](https://github.com/jessesquires/ReactiveCollectionsKit/pull/127))

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
