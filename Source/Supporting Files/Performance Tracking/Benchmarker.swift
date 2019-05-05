//
//  Benchmarker.swift
//  LogStu iOS
//
//  Created by Jason Stuemke on 5/5/19.
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
