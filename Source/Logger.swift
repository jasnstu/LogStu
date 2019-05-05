//
//  Logger.swift
//  LogStu
//
//  Created by Jason Stuemke on 5/5/19.
//

import Foundation

open class Logger {

    /// The logger state.
    public var enabled: Bool = true

    /// The logger formatter.
    public var formatter: Formatter {
        didSet { formatter.logger = self }
    }

    /// The logger theme.
    public var theme: Theme

    /// The minimum level of severity.
    public var minLevel: Level

    /// The logger format.
    public var format: String {
        return formatter.description
    }

    /// The logger colors
    public var colors: String {
        return theme.description
    }

    /// The queue used for logging.
    private let queue = DispatchQueue(label: "delba.log")
    private let benchmarker = Benchmarker()

    /// Creates and returns a new logger.
    ///
    /// - Parameters:
    ///   - formatter: The formatter.
    ///   - theme: The theme.
    ///   - minLevel: The minimum level of severity.
    public init(formatter: Formatter = .default, theme: Theme = .emojiHearts, minLevel: Level = .trace) {
        self.formatter = formatter
        self.theme = theme
        self.minLevel = minLevel

        formatter.logger = self
    }

    /// Logs a message with a trace severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func trace(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // swiftlint:disable:previous line_length
        log(.trace, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with a debug severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func debug(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // swiftlint:disable:previous line_length
        log(.debug, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with an info severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func info(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // swiftlint:disable:previous line_length
        log(.info, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with a warning severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func warning(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // swiftlint:disable:previous line_length
        log(.warning, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with an error severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func error(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // swiftlint:disable:previous line_length
        log(.error, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message.
    ///
    /// - Parameters:
    ///   - level: The severity level.
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    private func log(_ level: Level, _ items: [Any], _ separator: String, _ terminator: String, _ file: String, _ line: Int, _ column: Int, _ function: String) {
        // swiftlint:disable:previous line_length function_parameter_count
        guard enabled && level >= minLevel else {
            return
        }

        let date = Date()
        let result = formatter.format(level: level,
                                      items: items,
                                      separator: separator,
                                      terminator: terminator,
                                      file: file,
                                      line: line,
                                      column: column,
                                      function: function,
                                      date: date)
        queue.async {
            Swift.print(result, separator: "", terminator: "")
        }
    }

    /// Measures the performance of code.
    ///
    /// - Parameters:
    ///   - description: The measure description.
    ///   - n: The number of iterations.
    ///   - file: The file in which the measure happens.
    ///   - line: The line at which the measure happens.
    ///   - column: The column at which the measure happens.
    ///   - function: The function in which the measure happens.
    ///   - block: The block to measure.
    public func measure(_ description: String? = nil, iterations number: Int = 10, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function, block: () -> Void) {
        // swiftlint:disable:previous line_length
        guard enabled && .debug >= minLevel else {
            return
        }

        let measure = benchmarker.measure(description, iterations: number, block: block)
        let date = Date()
        let result = formatter.format(description: measure.description,
                                      average: measure.average,
                                      relativeStandardDeviation: measure.relativeStandardDeviation,
                                      file: file,
                                      line: line,
                                      column: column,
                                      function: function,
                                      date: date)
        queue.async {
            Swift.print(result)
        }
    }

}
