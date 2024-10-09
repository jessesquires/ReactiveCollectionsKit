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

import Foundation

/// Represents a section of items in a collection.
public struct SectionViewModel: DiffableViewModel {
    // MARK: DiffableViewModel

    /// A unique id for this model.
    public let id: UniqueIdentifier

    // MARK: Properties

    /// The cells in the section.
    public let cells: [AnyCellViewModel]

    /// The header for the section.
    public let header: AnySupplementaryViewModel?

    /// The footer for the section.
    public let footer: AnySupplementaryViewModel?

    /// The supplementary views in the section.
    public let supplementaryViews: [AnySupplementaryViewModel]

    /// Returns `true` if the section has supplementary views, `false` otherwise.
    public var hasSupplementaryViews: Bool {
        self.header != nil
        || self.footer != nil
        || self.supplementaryViews.isNotEmpty
    }

    // MARK: Init

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    ///   - header: The header for the section.
    ///   - footer: The footer for the section.
    ///   - supplementaryViews: The supplementary views in the section.
    public init(
        id: UniqueIdentifier,
        cells: [AnyCellViewModel] = [],
        header: AnySupplementaryViewModel? = nil,
        footer: AnySupplementaryViewModel? = nil,
        supplementaryViews: [AnySupplementaryViewModel] = []
    ) {
        self.init(
            id: id,
            anyCells: cells,
            anyHeader: header,
            anyFooter: footer,
            anySupplementaryViews: supplementaryViews
        )
    }

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    public init<Cell: CellViewModel>(
        id: UniqueIdentifier,
        cells: [Cell]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.eraseToAnyViewModel() },
            anyHeader: nil,
            anyFooter: nil,
            anySupplementaryViews: []
        )
    }

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    ///   - header: The header for the section.
    ///   - footer: The footer for the section.
    ///   - supplementaryViews: The supplementary views in the section.
    public init<Header: SupplementaryHeaderViewModel, Footer: SupplementaryFooterViewModel>(
        id: UniqueIdentifier,
        cells: [AnyCellViewModel] = [],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [AnySupplementaryViewModel] = []
    ) {
        self.init(
            id: id,
            anyCells: cells,
            anyHeader: header?.eraseToAnyViewModel(),
            anyFooter: footer?.eraseToAnyViewModel(),
            anySupplementaryViews: supplementaryViews
        )
    }

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    ///   - header: The header for the section.
    ///   - footer: The footer for the section.
    ///   - supplementaryViews: The supplementary views in the section.
    public init<Cell: CellViewModel, Header: SupplementaryHeaderViewModel, Footer: SupplementaryFooterViewModel>(
        id: UniqueIdentifier,
        cells: [Cell],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [AnySupplementaryViewModel] = []
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.eraseToAnyViewModel() },
            anyHeader: header?.eraseToAnyViewModel(),
            anyFooter: footer?.eraseToAnyViewModel(),
            anySupplementaryViews: supplementaryViews
        )
    }

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    ///   - header: The header for the section.
    ///   - footer: The footer for the section.
    ///   - supplementaryViews: The supplementary views in the section.
    public init<Cell: CellViewModel, View: SupplementaryViewModel>(
        id: UniqueIdentifier,
        cells: [Cell],
        header: AnySupplementaryViewModel? = nil,
        footer: AnySupplementaryViewModel? = nil,
        supplementaryViews: [View]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.eraseToAnyViewModel() },
            anyHeader: header,
            anyFooter: footer,
            anySupplementaryViews: supplementaryViews.map { $0.eraseToAnyViewModel() }
        )
    }

    /// Initializes a section.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section.
    ///   - cells: The cells in the section.
    ///   - header: The header for the section.
    ///   - footer: The footer for the section.
    ///   - supplementaryViews: The supplementary views in the section.
    public init<
        Cell: CellViewModel,
        Header: SupplementaryHeaderViewModel,
        Footer: SupplementaryFooterViewModel,
        View: SupplementaryViewModel>
    (
        id: UniqueIdentifier,
        cells: [Cell],
        header: Header?,
        footer: Footer?,
        supplementaryViews: [View]
    ) {
        self.init(
            id: id,
            anyCells: cells.map { $0.eraseToAnyViewModel() },
            anyHeader: header?.eraseToAnyViewModel(),
            anyFooter: footer?.eraseToAnyViewModel(),
            anySupplementaryViews: supplementaryViews.map { $0.eraseToAnyViewModel() }
        )
    }

    private init(
        id: UniqueIdentifier,
        anyCells: [AnyCellViewModel],
        anyHeader: AnySupplementaryViewModel?,
        anyFooter: AnySupplementaryViewModel?,
        anySupplementaryViews: [AnySupplementaryViewModel]
    ) {
        if let anyHeader { precondition(anyHeader.isHeader) }
        if let anyFooter { precondition(anyFooter.isFooter) }
        precondition(anySupplementaryViews.allSatisfy(\.isOtherSupplementaryView))
        self.id = id
        self.cells = anyCells
        self.header = anyHeader
        self.footer = anyFooter
        self.supplementaryViews = anySupplementaryViews
    }

    // MARK: Accessing Cells and Supplementary Views

    /// Returns the cell for the specified `id`.
    ///
    /// - Parameter id: The identifier for the cell.
    /// - Returns: The cell, if it exists.
    public func cellViewModel(for id: UniqueIdentifier) -> AnyCellViewModel? {
        self.cells.first { $0.id == id }
    }

    /// Returns the supplementary view for the specified `id`.
    ///
    /// - Parameter id: The identifier for the supplementary view.
    /// - Returns: The supplementary view, if it exists.
    public func supplementaryViewModel(for id: UniqueIdentifier) -> AnySupplementaryViewModel? {
        self.supplementaryViews.first { $0.id == id }
    }

    // MARK: Internal

    func cellRegistrations() -> Set<ViewRegistration> {
        Set(self.cells.map(\.registration))
    }

    func headerFooterRegistrations() -> Set<ViewRegistration> {
        Set([self.header, self.footer].compactMap { $0?.registration })
    }

    func supplementaryViewRegistrations() -> Set<ViewRegistration> {
        Set(self.supplementaryViews.map(\.registration))
    }

    func allRegistrations() -> Set<ViewRegistration> {
        let cells = self.cellRegistrations()
        let headerFooter = self.headerFooterRegistrations()
        let views = self.supplementaryViewRegistrations()
        return cells.union(views).union(headerFooter)
    }

    func allSupplementaryViewsByIdentifier() -> [UniqueIdentifier: AnySupplementaryViewModel] {
        let tuples = self.supplementaryViews.map { ($0.id, $0) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }
}

// MARK: Collection, RandomAccessCollection

extension SectionViewModel: Collection, RandomAccessCollection {
    /// :nodoc:
    public var count: Int {
        self.cells.count
    }

    /// :nodoc:
    public var isEmpty: Bool {
        self.cells.isEmpty
    }

    /// :nodoc:
    public var startIndex: Int {
        self.cells.startIndex
    }

    /// :nodoc:
    public var endIndex: Int {
        self.cells.endIndex
    }

    /// :nodoc:
    public subscript(position: Int) -> AnyCellViewModel {
        self.cells[position]
    }

    /// :nodoc:
    public func index(after pos: Int) -> Int {
        self.cells.index(after: pos)
    }
}

extension SectionViewModel: CustomDebugStringConvertible {
    /// :nodoc:
    public var debugDescription: String {
        sectionDebugDescription(self)
    }
}
