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
//  Formatters.swift
//  LogStu
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
