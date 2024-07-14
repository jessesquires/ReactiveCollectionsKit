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

/// :nodoc:
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

/// :nodoc:
private func print<Target: TextOutputStream>(
    _ text: String,
    indent: Int,
    to output: inout Target
) {
    Swift.print("\(String(repeating: " ", count: indent))\(text)", to: &output)
}

/// :nodoc:
private func print<Target: TextOutputStream>(
    elements: [(Element, Int)],
    to output: inout Target
) {
    for (element, indent) in elements {
        switch element {
        case let .type(type):
            print("<\(type):", indent: indent, to: &output)

        case let .index(index):
            print("[\(index)]:", indent: indent, to: &output)

        case let .id(id):
            print("id: \(id)", indent: indent, to: &output)

        case let .header(header):
            if let header {
                print("header: \(header.id) (\(header.reuseIdentifier))", indent: indent, to: &output)
            } else {
                print("header: nil", indent: indent, to: &output)
            }

        case let .footer(footer):
            if let footer {
                print("footer: \(footer.id) (\(footer.reuseIdentifier))", indent: indent, to: &output)
            } else {
                print("footer: nil", indent: indent, to: &output)
            }

        case let .cells(cells):
            if !cells.isEmpty {
                print("cells:", indent: indent, to: &output)
            } else {
                print("cells: none", indent: indent, to: &output)
            }

            for (index, cell) in cells.enumerated() {
                print("[\(index)]: \(cell.id) (\(cell.reuseIdentifier))", indent: indent + 2, to: &output)
            }

        case let .supplementaryViews(supplementaryViews):
            if !supplementaryViews.isEmpty {
                print("supplementary views:", indent: indent, to: &output)
            } else {
                print("supplementary views: none", indent: indent, to: &output)
            }

            for (index, supplementaryView) in supplementaryViews.enumerated() {
                print("[\(index)]: \(supplementaryView.id) (\(supplementaryView.reuseIdentifier))", indent: indent + 2, to: &output)
            }

        case let .sections(sections):
            if !sections.isEmpty {
                print("sections:", indent: indent, to: &output)
            } else {
                print("sections: none", indent: indent, to: &output)
            }

            for (index, section) in sections.enumerated() {
                print(
                    elements: [
                        (.index(index), indent + 2),
                        (.id(section.id), indent + 4),
                        (.header(section.header), indent + 4),
                        (.footer(section.footer), indent + 4),
                        (.cells(section.cells), indent + 4),
                        (.supplementaryViews(section.supplementaryViews), indent + 4),
                        (.isEmpty(section.isEmpty), indent + 4),
                    ],
                    to: &output
                )
            }

        case let .registrations(registrations):
            if !registrations.isEmpty {
                print("registrations:", indent: indent, to: &output)
            } else {
                print("registrations: none", indent: indent, to: &output)
            }

            for registration in registrations.sorted(by: { $0.reuseIdentifier < $1.reuseIdentifier }) {
                print("- \(registration.reuseIdentifier) (\(registration.viewType.kind))", indent: indent + 2, to: &output)
            }

        case let .isEmpty(isEmpty):
            print("isEmpty: \(isEmpty)", indent: indent, to: &output)

        case .end:
            print(">", indent: indent, to: &output)
        }
    }
}

/// :nodoc:
@MainActor
func collectionDescription(for collection: CollectionViewModel) -> String {
    var output = ""
    print(
        elements: [
            (.type(CollectionViewModel.self), 0),
            (.id(collection.id), 2),
            (.sections(collection.sections), 2),
            (.registrations(collection.allRegistrations()), 2),
            (.isEmpty(collection.isEmpty), 2),
            (.end, 0),
        ],
        to: &output
    )
    return output
}

/// :nodoc:
@MainActor
func sectionDescription(for section: SectionViewModel) -> String {
    var output = ""
    print(
        elements: [
            (.type(SectionViewModel.self), 0),
            (.id(section.id), 2),
            (.header(section.header), 2),
            (.footer(section.footer), 2),
            (.cells(section.cells), 2),
            (.supplementaryViews(section.supplementaryViews), 2),
            (.registrations(section.allRegistrations()), 2),
            (.isEmpty(section.isEmpty), 2),
            (.end, 0),
        ],
        to: &output
    )
    return output
}
