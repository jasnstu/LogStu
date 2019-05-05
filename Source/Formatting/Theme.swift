//
//  Theme.swift
//  LogStu
//
//  Created by Jason Stuemke on 5/5/19.
//

import Foundation

public class Theme: Themes {

    /// Style object to hold color and emoji for each level.
    public struct Style {

        /// Color for the syyle.
        public let color: String?

        /// Emoji for the style.
        public let emoji: String

        /// Creates and returns a style with the specified color or/and emoji.
        ///
        /// - Parameters:
        ///   - color: The color for the style.
        ///   - emoji: The emoji for the style.
        public init(color: String? = nil, emoji: String? = nil) {
            self.color = color

            if let emoji = emoji {
                self.emoji = emoji + " "
            } else {
                self.emoji = ""
            }
        }

    }

    /// The theme styles.
    private var styles: [Level: Style]

    /// Returns style for the specified level.
    ///
    /// - Parameter level: The level for which style needs to be selected.
    /// - Returns: A style for specific level.
    internal func style(for level: Level) -> Style? {
        return styles[level]
    }

    /// The theme textual representation.
    internal var description: String {
        return styles.keys.sorted().map {
            var string = (styles[$0]?.emoji ?? "") + $0.description

            if let color = styles[$0]?.color {
                string = string.withColor(color)
            }

            return string
            }.joined(separator: " ")
    }

    /// Creates and returns a theme with the specified colors.
    /// **WARNING**: Deprecated!
    /// Use `init( trace: Style, debug: Style, info: Style, warning: Style, error: Style)` instead.
    ///
    /// - Parameters:
    ///   - trace: The color for the trace level.
    ///   - debug: The color for the debug level.
    ///   - info: The color for the info level.
    ///   - warning: The color for the warning level.
    ///   - error: The color for the error level.
    @available(*, deprecated)
    public init(trace: String, debug: String, info: String, warning: String, error: String) {
        self.styles = [
            .trace: Style(color: Theme.formatHex(trace)),
            .debug: Style(color: Theme.formatHex(debug)),
            .info: Style(color: Theme.formatHex(info)),
            .warning: Style(color: Theme.formatHex(warning)),
            .error: Style(color: Theme.formatHex(error)),
        ]
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

    /// Returns a string representation of the hex color.
    ///
    /// - Parameter hex: The hex color.
    /// - Returns: A string representation of the hex color.
    private static func formatHex(_ hex: String) -> String {
        let scanner = Scanner(string: hex)
        var hex: UInt32 = 0

        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hex)

        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = (hex & 0xFF)

        return [red, green, blue].map({ String($0) }).joined(separator: ",")
    }

}