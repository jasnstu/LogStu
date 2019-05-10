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
//  Benchmarker.swift
//  LogStu iOS
//

import Foundation

class Benchmarker {

    typealias Result = (description: String?, average: Double, relativeStandardDeviation: Double)

    /// Measures the performance of code.
    ///
    /// - Parameters:
    ///   - description: The measure description.
    ///   - number: The number of iterations.
    ///   - block: The block to measure.
    /// - Returns: The measure result.
    func measure(_ description: String? = nil, iterations number: Int = 10, block: () -> Void) -> Result {
        precondition(number >= 1, "Iteration must be greater or equal to 1.")

        let durations = (0..<number).map { _ in
            duration {
                block()
            }
        }

        let average = self.average(durations)
        let standardDeviation = self.standardDeviation(average, durations: durations)
        let relativeStandardDeviation = standardDeviation * average * 100

        return (description: description, average: average, relativeStandardDeviation: relativeStandardDeviation)
    }

}

// MARK: - Private

private extension Benchmarker {

    func duration(_ block: () -> Void) -> Double {
        let date = Date()

        block()

        return abs(date.timeIntervalSinceNow)
    }

    func average(_ durations: [Double]) -> Double {
        return durations.reduce(0, +) / Double(durations.count)
    }

    func standardDeviation(_ average: Double, durations: [Double]) -> Double {
        return durations.reduce(0) { sum, duration in
            return sum + pow(duration - average, 2)
        }
    }

}
