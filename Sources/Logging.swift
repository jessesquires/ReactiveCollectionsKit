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

/// A type that logs messages.
public protocol Logging: Sendable {

    /// Logs the message.
    /// - Parameter message: The message to log.
    func log(_ message: @autoclosure () -> String)
}
