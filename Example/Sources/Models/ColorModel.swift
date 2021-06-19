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

struct ColorModel: Equatable, Hashable, CustomStringConvertible {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    var description: String {
        "(\(Int(red * 255)), \(Int(green * 255)), \(Int(blue * 255)))"
    }
}

extension ColorModel {
    static var random: ColorModel {
        ColorModel(red: CGFloat.random256(), green: CGFloat.random256(), blue: CGFloat.random256())
    }
}

extension CGFloat {
    static func random256() -> CGFloat {
        CGFloat((0..<256).randomElement()!) / 255
    }
}

extension ColorModel {
    static func makeColors() -> [ColorModel] {
        (0..<10).map { _ in ColorModel.random }
    }
}
