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
//  Theme.swift
//  LogStu
//

import Foundation

public class Theme: Themes {

    /// Style object to hold emoji for each level.
    public struct Style {

        /// Emoji for the style.
        public let emoji: String

        /// Creates and returns a style with the specified emoji.
        ///
        /// - Parameters:
        ///   - emoji: The emoji for the style.
        public init(emoji: String? = nil) {
            if let emoji = emoji {
                self.emoji = emoji + " "
            } else {
                self.emoji = ""
            }
        }

    }

    /// The theme styles.
    private var styles: [LoggingLevel: Style]

    /// Returns style for the specified level.
    ///
    /// - Parameter level: The level for which style needs to be selected.
    /// - Returns: A style for specific level.
    internal func style(for level: LoggingLevel) -> Style? {
        return styles[level]
    }

    /// The theme textual representation.
    internal var description: String {
        return styles.keys.sorted().map { (styles[$0]?.emoji ?? "") + $0.description }.joined(separator: " ")
    }

    /// Creates and returns a theme with the specified styles.
    ///
    /// - Parameters:
    ///   - trace: The style for the trace level.
    ///   - debug: The style for the debug level.
    ///   - info: The style for the info level.
    ///   - warning: The style for the warning level.
    ///   - error: The style for the error level.
    public init(trace: Style, debug: Style, info: Style, warning: Style, error: Style) {
        self.styles = [
            .trace: trace,
            .debug: debug,
            .info: info,
            .warning: warning,
            .error: error
        ]
    }

}
