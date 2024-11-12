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

/// The default logger implementation.
final class Logger: Logging {

    /// The shared logger instance.
    static let shared = Logger()

    func log(_ message: @autoclosure () -> String) {
        print(message())
    }
}
