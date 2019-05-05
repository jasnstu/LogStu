//
//  LoggingLevel.swift
//  LogStu iOS
//
//  Created by Jason Stuemke on 5/5/19.
//

public enum Level: Int {

    case trace, debug, info, warning, error

    var description: String {
        return String(describing: self).uppercased()
    }

}

extension Level: Comparable { }

public func == (left: Level, right: Level) -> Bool {
    return left.rawValue == right.rawValue
}

public func < (left: Level, right: Level) -> Bool {
    return left.rawValue < right.rawValue
}
