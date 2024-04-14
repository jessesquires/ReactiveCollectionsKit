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

import ReactiveCollectionsKit
import UIKit

enum Color: String, Hashable, CaseIterable {
    case blue
    case brown
    case green
    case indigo
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
}

struct ColorModel: Hashable {
    let color: Color
    var isFavorite = false

    var name: String {
        self.color.rawValue
    }

    var id: UniqueIdentifier {
        self.color.rawValue
    }

    var uiColor: UIColor {
        switch self.color {
        case .blue:
            return .systemBlue

        case .brown:
            return .systemBrown

        case .green:
            return .systemGreen

        case .indigo:
            return .systemIndigo

        case .orange:
            return .systemOrange

        case .pink:
            return .systemPink

        case .purple:
            return .systemPurple

        case .red:
            return .systemRed

        case .teal:
            return .systemTeal

        case .yellow:
            return .systemYellow
        }
    }
}

extension ColorModel {
    static func makeColors() -> [ColorModel] {
        Color.allCases.map { ColorModel(color: $0) }
    }
}
