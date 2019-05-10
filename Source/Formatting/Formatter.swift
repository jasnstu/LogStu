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
//  Formatter.swift
//  LogStu
//

import Foundation

public class Formatter: Formatters {

    /// The formatter format.
    private var format: String

    /// The formatter components.
    private var components: [Component]

    /// The date formatter.
    fileprivate let dateFormatter = DateFormatter()

    /// The formatter logger.
    internal weak var logger: Logger!

    /// The formatter textual representation.
    internal var description: String {
        return String(format: format, arguments: components.map { (component: Component) -> CVarArg in
            return String(describing: component).uppercased()
        })
    }

    /// Creates and returns a new formatter with the specified format and components.
    ///
    /// - Parameters:
    ///   - format: The formatter format.
    ///   - components: The formatter components.
    public convenience init(_ format: String, _ components: Component...) {
        self.init(format, components)
    }

    /// Creates and returns a new formatter with the specified format and components.
    ///
    /// - Parameters:
    ///   - format: The formatter format.
    ///   - components: The formatter components.
    public init(_ format: String, _ components: [Component]) {
        self.format = format
        self.components = components
    }

    /// Formats a string with the formatter format and components.
    ///
    /// - Parameters:
    ///   - level: The severity level.
    ///   - items: The items to format.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the formatted string.
    ///   - file: The log file path.
    ///   - line: The log line number.
    ///   - column: The log column number.
    ///   - function: The log function.
    ///   - date: The log date.
    /// - Returns: A formatted string.
    internal func format(level: Level, items: [Any], separator: String, terminator: String, file: String, line: Int, column: Int, function: String, date: Date) -> String {
        // swiftlint:disable:previous line_length function_parameter_count

        let arguments = components.map { (component: Component) -> CVarArg in
            switch component {
            case .date(let dateFormat):
                return format(date: date, dateFormat: dateFormat)
            case .file(let fullPath, let fileExtension):
                return format(file: file, fullPath: fullPath, fileExtension: fileExtension)
            case .function:
                return String(function)
            case .line:
                return String(line)
            case .column:
                return String(column)
            case .level:
                return format(level: level)
            case .message:
                return items.map({ String(describing: $0) }).joined(separator: separator)
            case .location:
                return format(file: file, line: line)
            case .block(let block):
                return block().flatMap({ String(describing: $0) }) ?? ""
            }
        }

        return String(format: format, arguments: arguments) + terminator
    }

    /// Formats a string with the formatter format and components.
    ///
    /// - Parameters:
    ///   - description: The measure description.
    ///   - average: The average time.
    ///   - relativeStandardDeviation: The relative standard description.
    ///   - file: The log file path.
    ///   - line: The log line number.
    ///   - column: The log column number.
    ///   - function: The log function.
    ///   - date: The log date.
    /// - Returns: A formatted string.
    func format(description: String?, average: Double, relativeStandardDeviation: Double, file: String, line: Int, column: Int, function: String, date: Date) -> String {
        // swiftlint:disable:previous line_length function_parameter_count

        let arguments = components.map { (component: Component) -> CVarArg in
            switch component {
            case .date(let dateFormat):
                return format(date: date, dateFormat: dateFormat)
            case .file(let fullPath, let fileExtension):
                return format(file: file, fullPath: fullPath, fileExtension: fileExtension)
            case .function:
                return String(function)
            case .line:
                return String(line)
            case .column:
                return String(column)
            case .level:
                return format(description: description)
            case .message:
                return format(average: average, relativeStandardDeviation: relativeStandardDeviation)
            case .location:
                return format(file: file, line: line)
            case .block(let block):
                return block().flatMap({ String(describing: $0) }) ?? ""
            }
        }

        return String(format: format, arguments: arguments)
    }

}

// MARK: - Private

private extension Formatter {

    /// Formats a date with the specified date format.
    ///
    /// - Parameters:
    ///   - date: The date.
    ///   - dateFormat: The date format.
    /// - Returns: A formatted date.
    func format(date: Date, dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    /// Formats a file path with the specified parameters.
    ///
    /// - Parameters:
    ///   - file: The file path.
    ///   - fullPath: Whether the full path should be included.
    ///   - fileExtension: Whether the file extension should be included.
    /// - Returns: A formatted file path.
    func format(file: String, fullPath: Bool, fileExtension: Bool) -> String {
        var file = file

        if !fullPath {
            file = file.lastPathComponent
        }

        if !fileExtension {
            file = file.stringByDeletingPathExtension
        }

        return file
    }

    /// Formats a Location component with a specified file path and line number.
    ///
    /// - Parameters:
    ///   - file: The file path.
    ///   - line: The line number.
    /// - Returns: A formatted Location component.
    func format(file: String, line: Int) -> String {
        return [
            format(file: file, fullPath: false, fileExtension: true),
            String(line),
            ].joined(separator: ":")
    }

    /// Formats a Level component.
    ///
    /// - Parameter level: The Level component.
    /// - Returns: A formatted Level component.
    func format(level: Level) -> String {
        let text = level.description

        if let style = logger.theme.style(for: level) {
            var styledString = style.emoji + text

            if let color = style.color {
                styledString = styledString.withColor(color)
            }

            return styledString
        }

        return text
    }

    /// Formats a measure description.
    ///
    /// - Parameter description: The measure description.
    /// - Returns: A formatted measure description.
    func format(description: String?) -> String {
        var text = "MEASURE"

        if let style = logger.theme.style(for: .debug) {
            text = style.emoji + text

            if let color = style.color {
                text = text.withColor(color)
            }
        }

        if let description = description {
            text = "\(text) \(description)"
        }

        return text
    }

    /// Formats an average time and a relative standard deviation.
    ///
    /// - Parameters:
    ///   - average: The average time.
    ///   - relativeStandardDeviation: The relative standard deviation.
    /// - Returns: A formatted average time and relative standard deviation.
    func format(average: Double, relativeStandardDeviation: Double) -> String {
        let average = format(average: average)
        let relativeStandardDeviation = format(relativeStandardDeviation: relativeStandardDeviation)

        return "Time: \(average) sec (\(relativeStandardDeviation) STDEV)"
    }

    /// Formats an average time.
    ///
    /// - Parameter average: average: An average time.
    /// - Returns: A formatted average time.
    func format(average: Double) -> String {
        return String(format: "%.3f", average)
    }

    /// Formats a list of durations.
    ///
    /// - Parameter durations: A list of durations.
    /// - Returns: A formatted list of durations.
    func format(durations: [Double]) -> String {
        var format = Array(repeating: "%.6f", count: durations.count).joined(separator: ", ")
        format = "[\(format)]"

        return String(format: format, arguments: durations.map { $0 as CVarArg })
    }

    /// Formats a standard deviation.
    ///
    /// - Parameter standardDeviation: A standard deviation.
    /// - Returns: A formatted standard deviation.
    func format(standardDeviation: Double) -> String {
        return String(format: "%.6f", standardDeviation)
    }

    /// Formats a relative standard deviation.
    ///
    /// - Parameter relativeStandardDeviation: A relative standard deviation.
    /// - Returns: A formatted relative standard deviation.
    func format(relativeStandardDeviation: Double) -> String {
        return String(format: "%.3f%%", relativeStandardDeviation)
    }

}
