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
import OSLog

/// Describes a type that logs messages for the library.
public protocol Logging: Sendable {

    /// Logs the provided message.
    ///
    /// - Parameter message: The message to log.
    func log(_ message: @escaping @autoclosure () -> String)
}

/// A default ``Logging`` implementation to log debug messages.
///
/// You can set this logger for the ``CollectionViewDriver.logger``.
public final class RCKLogger: Logging {
    /// The shared logger instance.
    public static let shared = RCKLogger()

    private let _logger = Logger(subsystem: "com.jessesquires.ReactiveCollectionsKit", category: "")

    /// :nodoc:
    public func log(_ message: @escaping @autoclosure () -> String) {
        self._logger.debug("\(message())")
    }
}
