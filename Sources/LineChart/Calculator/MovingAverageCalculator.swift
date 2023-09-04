//
//  MovingAverageCalculator.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import ChartCore

/// A calculator that calculates the moving average of entries.
public struct MovingAverageCalculator {
    private let range: Int

    /// Creates an instance that calculates the moving average of entries.
    ///
    /// - Parameter range: The range of the moving average. The value must be an
    ///   odd number and greater than or equal to 1.
    public init(range: Int) {
        precondition(range % 2 == 1 && range >= 1)

        self.range = range
    }

    public func callAsFunction(_ entries: [OptionalEntry]) -> [OptionalEntry] {
        entries.chunked().reduce(into: []) { result, chunk in
            switch chunk {
            case .entry(let entries):
                result += calculate(entries).map { $0.toOptionalEntry() }

            case .optionalEntry(let xs):
                result += xs.map { OptionalEntry(x: $0, y: nil) }
            }
        }
    }

    /// Calculates the moving average of given points.
    public func calculate(_ entries: [Entry]) -> [Entry] {
        // Calculate MA for given points.
        // It uses Two Pointers Algorithm (尺取法) to reduce cost.

        var result = [Entry]()
        var sum = sum(at: 0, entries: entries)
        result.append(Entry(x: entries[0].x, y: sum / Double(range)))

        let r = range / 2
        for i in entries.indices.dropFirst() {
            let old = entryAt(clampingIndex: i - r - 1, entries: entries)
            let new = entryAt(clampingIndex: i + r, entries: entries)

            sum -= old.y
            sum += new.y
            result.append(Entry(x: entries[i].x, y: sum / Double(range)))
        }

        return result
    }

    private func sum(at index: Int, entries: [Entry]) -> Double {
        let r = range / 2
        var sum = 0.0
        for i in -r...r {
            let e = entryAt(clampingIndex: index + i, entries: entries)
            sum += e.y
        }

        return sum
    }

    private func entryAt(clampingIndex index: Int, entries: [Entry]) -> Entry {
        entries[max(0, min(index, entries.count - 1))]
    }
}
