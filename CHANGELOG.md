# Changelog

The changelog for `ReactiveCollectionsKit`. Also see [the releases on GitHub](https://github.com/jessesquires/ReactiveCollectionsKit/releases).

NEXT
-----

- TBA

0.1.2
-----

- Fixed bug when chaining multiple calls to `eraseToAnyViewModel()` for both `CellViewModel` and and `SupplementaryViewModel`. Previously, it was possible "double erase" a view model by calling `eraseToAnyViewModel()` multiple times, thus actually losing type information. Now, consecutive calls to `eraseToAnyViewModel()` have no effect. ([@nuomi1](https://github.com/nuomi1), [#117](https://github.com/jessesquires/ReactiveCollectionsKit/pull/117))

0.1.1
-----

- Documentation updates.

0.1.0
-----

Initial release. 🎉
