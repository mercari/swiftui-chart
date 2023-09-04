//
//  MixedValueCalculator.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import ChartCore

/// A calculator that calculates the mixed values of arrays of entries.
public struct MixedValueCalculator {
    private let ratio: Double

    /// Creates an instance that calculates the mixed values of arrays of 
    /// entries.
    ///
    /// - Parameter ratio: The ratio of the mixed values. The value must be in 
    ///   the range of 0 to 1. 0 means the left entries, 1 means the right
    ///   entries.
    public init(ratio: Double) {
        precondition((0...1).contains(ratio))

        self.ratio = ratio
    }

    public func callAsFunction(_ lEntries: [OptionalEntry], _ rEntries: [OptionalEntry]) -> [OptionalEntry] {
        zip(lEntries, rEntries).map { lhs, rhs in
            switch (lhs.toEntry(), rhs.toEntry()) {
            case (let lhs?, let rhs?):
                return OptionalEntry(x: lhs.x, y: (1 - ratio) * lhs.y + ratio * rhs.y)

            case (let entry?, nil),
                 (nil, let entry?):
                return OptionalEntry(x: lhs.x, y: entry.y)

            case (nil, nil):
                return OptionalEntry(x: lhs.x, y: nil)
            }
        }
    }
}
