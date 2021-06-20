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

import UIKit

enum ColorModel: String, Equatable, Hashable, CaseIterable {
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

    var name: String {
        self.rawValue
    }

    var uiColor: UIColor {
        switch self {
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
        ColorModel.allCases
    }
}
