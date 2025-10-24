// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Logging

public protocol ILogger: Sendable {
    func log(level: LogLevel,
             message: @autoclosure () -> String
    )
}

public struct Logger: ILogger, Sendable {
    private let logger: Logging.Logger

    public init(label: String) {
        logger = Logging.Logger(label: label)
    }

    public func log(level: LogLevel, message: @autoclosure () -> String) {
        logger.log(level: level.toLoggingLevel(), .init(stringLiteral: message()))
    }
}

public struct NoLogger: ILogger, Sendable {
    private let logger: Logging.Logger

    public init(label: String) {
        logger = Logging.Logger(label: label)
    }

    public func log(level _: LogLevel, message _: @autoclosure () -> String) {
        // Do nothing
    }
}

public enum LogLevel {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical

    func toLoggingLevel() -> Logging.Logger.Level {
        switch self {
        case .trace:
            return .trace
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            return .notice
        case .warning:
            return .warning
        case .error:
            return .error
        case .critical:
            return .critical
        }
    }
}
