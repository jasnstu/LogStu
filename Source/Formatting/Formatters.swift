//
//  Formatters.swift
//  LogStu
//
//  Created by Jason Stuemke on 5/5/19.
//

public class Formatters {

    public static let `default` = Formatter("[%@] %@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .location,
        .level,
        .message,
        ])
    public static let minimal = Formatter("%@ %@: %@", [
        .location,
        .level,
        .message,
        ])
    public static let detailed = Formatter("[%@] %@.%@:%@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .file(fullPath: false, fileExtension: false),
        .function,
        .line,
        .level,
        .message,
        ])

}
