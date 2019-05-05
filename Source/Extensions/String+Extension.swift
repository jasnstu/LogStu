//
//  String+Extension.swift
//  LogStu
//
//  Created by Jason Stuemke on 5/5/19.
//

import Foundation

extension String {

    /// The last path component of the receiver.
    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }

    /// A new string made by deleting the extension from the receiver.
    var stringByDeletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }

    /// Returns a string colored with the specified color.
    ///
    /// - Parameter color: The string representation of the color.
    /// - Returns: A string colored with the specified color.
    func withColor(_ color: String) -> String {
        return "\u{001b}[fg\(color);\(self)\u{001b}[;"
    }

}
