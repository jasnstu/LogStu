//    Copyright (c) 2019 jasnstu (http://jasnstu.com))
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//
//
//  Logger.swift
//  LogStu
//

import Foundation

open class Logger {

    /// The logger state.
    public var enabled: Bool = true

    /// The logger formatter.
    public var formatter: Formatter {
        didSet {
            formatter.logger = self
        }
    }

    /// The logger theme.
    public var theme: Theme

    /// The minimum level of severity.
    public var minLevel: LoggingLevel

    /// The logger format.
    public var format: String {
        return formatter.description
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
    public init(formatter: Formatter = .default, theme: Theme = .emojiHearts, minLevel: LoggingLevel = .trace) {
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
    private func log(_ level: LoggingLevel, _ items: [Any], _ separator: String, _ terminator: String, _ file: String, _ line: Int, _ column: Int, _ function: String) {
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
