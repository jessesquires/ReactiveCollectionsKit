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

struct ColorModel {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension ColorModel {
    static var random: ColorModel {
        let rand = { CGFloat((0..<256).randomElement()!) / 255 }
        return ColorModel(red: rand(), green: rand(), blue: rand())
    }
}

extension ColorModel {
    static func makeColors() -> [ColorModel] {
        return (0...14).map { _ in ColorModel.random }
    }
}
