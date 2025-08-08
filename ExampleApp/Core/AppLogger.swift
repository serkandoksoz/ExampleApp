//
//  AppLogger.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import OSLog

/// A logger wrapper to handle logs with categories and different levels.
struct AppLogger {

    /// Log level enum to manage different types of logs
    enum LogLevel {
        case debug
        case info
        case error
        case critical

        /// Returns the appropriate `OSLogType` for the given log level
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            case .critical:
                return .fault
            }
        }
    }

    /// Internal logger instance from `OSLog`
    private let logger: os.Logger

    /// Initializes the logger with a category.
    /// - Parameters:
    ///   - subsystem: Subsystem identifier, default to app's bundle identifier.
    ///   - category: Log category (e.g., "Networking", "UI").
    ///
    /// # Example usage:
    /// ```
    /// let networkLogger = AppLogger(category: "Networking")
    /// let uiLogger = AppLogger(category: "UI")
    ///
    /// networkLogger.debug("Request started")
    /// uiLogger.info("Button clicked")
    ///
    /// networkLogger.error("Failed to fetch data")
    /// uiLogger.critical("UI crash detected")
    /// ```
    init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.kanatom.tvremote", category: String) {
        logger = os.Logger(subsystem: subsystem, category: category)
    }

    // MARK: - Logging Methods

    /// Logs a message with the specified log level.
    /// - Parameters:
    ///   - level: The log level (debug, info, error, or critical).
    ///   - message: The log message, which can be of any type.
    ///   - file: Automatically captures the file name where the log is called (optional).
    ///   - function: Automatically captures the function name where the log is called (optional).
    ///   - line: Automatically captures the line number where the log is called (optional).
    func log(level: LogLevel, message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let messageString = String(describing: message)
        logger.log(level: level.osLogType, "\(fileName, privacy: .public):\(line) \(function, privacy: .public) -> \(messageString, privacy: .public)")
    }

    /// Log a debug message
    /// - Parameters:
    ///   - message: The message to log, which can be of any type.
    ///   - file: The file where the log is called.
    ///   - function: The function where the log is called.
    ///   - line: The line number where the log is called.
    func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message, file: file, function: function, line: line)
    }

    /// Log an informational message
    /// - Parameters:
    ///   - message: The message to log, which can be of any type.
    ///   - file: The file where the log is called.
    ///   - function: The function where the log is called.
    ///   - line: The line number where the log is called.
    func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }

    /// Log an error message
    /// - Parameters:
    ///   - message: The message to log, which can be of any type.
    ///   - file: The file where the log is called.
    ///   - function: The function where the log is called.
    ///   - line: The line number where the log is called.
    func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }

    /// Log a critical message
    /// - Parameters:
    ///   - message: The message to log, which can be of any type.
    ///   - file: The file where the log is called.
    ///   - function: The function where the log is called.
    ///   - line: The line number where the log is called.
    func critical(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .critical, message: message, file: file, function: function, line: line)
    }
}
