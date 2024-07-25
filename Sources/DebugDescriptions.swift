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

private enum Element {
    case type(Any.Type)
    case index(Int)
    case id(UniqueIdentifier)
    case header(AnySupplementaryViewModel?)
    case footer(AnySupplementaryViewModel?)
    case cells([AnyCellViewModel])
    case supplementaryViews([AnySupplementaryViewModel])
    case sections([SectionViewModel])
    case registrations(Set<ViewRegistration>)
    case isEmpty(Bool)
    case end
}

private func buildString<Target: TextOutputStream>(
    _ text: String,
    indent: Int,
    to output: inout Target
) {
    print("\(String(repeating: " ", count: indent))\(text)", to: &output)
}

// swiftlint:disable:next cyclomatic_complexity
private func debugDescriptionBuilder<Target: TextOutputStream>(
    elements: [(Element, Int)],
    to output: inout Target
) {
    for (element, indent) in elements {
        switch element {
        case let .type(type):
            buildString("<\(type):", indent: indent, to: &output)

        case let .index(index):
            buildString("[\(index)]:", indent: indent, to: &output)

        case let .id(id):
            buildString("id: \(id)", indent: indent, to: &output)

        case let .header(header):
            if let header {
                buildString("header: \(header.id) (\(header.reuseIdentifier))", indent: indent, to: &output)
            } else {
                buildString("header: nil", indent: indent, to: &output)
            }

        case let .footer(footer):
            if let footer {
                buildString("footer: \(footer.id) (\(footer.reuseIdentifier))", indent: indent, to: &output)
            } else {
                buildString("footer: nil", indent: indent, to: &output)
            }

        case let .cells(cells):
            if !cells.isEmpty {
                buildString("cells:", indent: indent, to: &output)
            } else {
                buildString("cells: none", indent: indent, to: &output)
            }

            for (index, cell) in cells.enumerated() {
                buildString("[\(index)]: \(cell.id) (\(cell.reuseIdentifier))", indent: indent + 2, to: &output)
            }

        case let .supplementaryViews(supplementaryViews):
            if !supplementaryViews.isEmpty {
                buildString("supplementary views:", indent: indent, to: &output)
            } else {
                buildString("supplementary views: none", indent: indent, to: &output)
            }

            for (index, supplementaryView) in supplementaryViews.enumerated() {
                buildString("[\(index)]: \(supplementaryView.id) (\(supplementaryView.reuseIdentifier))", indent: indent + 2, to: &output)
            }

        case let .sections(sections):
            if !sections.isEmpty {
                buildString("sections:", indent: indent, to: &output)
            } else {
                buildString("sections: none", indent: indent, to: &output)
            }

            for (index, section) in sections.enumerated() {
                debugDescriptionBuilder(
                    elements: [
                        (.index(index), indent + 2),
                        (.id(section.id), indent + 4),
                        (.header(section.header), indent + 4),
                        (.footer(section.footer), indent + 4),
                        (.cells(section.cells), indent + 4),
                        (.supplementaryViews(section.supplementaryViews), indent + 4),
                        (.isEmpty(section.isEmpty), indent + 4)
                    ],
                    to: &output
                )
            }

        case let .registrations(registrations):
            if !registrations.isEmpty {
                buildString("registrations:", indent: indent, to: &output)
            } else {
                buildString("registrations: none", indent: indent, to: &output)
            }

            for registration in registrations.sorted(by: { $0.reuseIdentifier < $1.reuseIdentifier }) {
                buildString("- \(registration.reuseIdentifier) (\(registration.viewType.kind))", indent: indent + 2, to: &output)
            }

        case let .isEmpty(isEmpty):
            buildString("isEmpty: \(isEmpty)", indent: indent, to: &output)

        case .end:
            buildString(">", indent: indent, to: &output)
        }
    }
}

@MainActor
func collectionDebugDescription(_ collection: CollectionViewModel) -> String {
    var output = ""
    debugDescriptionBuilder(
        elements: [
            (.type(CollectionViewModel.self), 0),
            (.id(collection.id), 2),
            (.sections(collection.sections), 2),
            (.registrations(collection.allRegistrations()), 2),
            (.isEmpty(collection.isEmpty), 2),
            (.end, 0)
        ],
        to: &output
    )
    return output
}

@MainActor
func sectionDebugDescription(_ section: SectionViewModel) -> String {
    var output = ""
    debugDescriptionBuilder(
        elements: [
            (.type(SectionViewModel.self), 0),
            (.id(section.id), 2),
            (.header(section.header), 2),
            (.footer(section.footer), 2),
            (.cells(section.cells), 2),
            (.supplementaryViews(section.supplementaryViews), 2),
            (.registrations(section.allRegistrations()), 2),
            (.isEmpty(section.isEmpty), 2),
            (.end, 0)
        ],
        to: &output
    )
    return output
}
