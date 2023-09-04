//
//  Entry.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import Foundation

/// A single entry for a chart.
public struct Entry: Hashable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public func toOptionalEntry() -> OptionalEntry {
        OptionalEntry(x: x, y: y)
    }
}

/// A single entry for a chart. `y` value can be `nil`.
public struct OptionalEntry: Hashable {
    public let x: Double
    public let y: Double?

    public init(x: Double, y: Double?) {
        self.x = x
        self.y = y
    }

    public func toEntry() -> Entry? {
        guard let y else {
            return nil
        }

        return Entry(x: x, y: y)
    }
}

/// A chunk from a sequence of entries.
/// 
/// "Chunk" means a sequence of entries that has the same optional condition of 
/// `y` value.
public enum EntryChunk: Hashable {
    case entry([Entry])
    case optionalEntry(xs: [Double])
}
