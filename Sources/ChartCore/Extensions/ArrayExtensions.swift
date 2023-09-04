//
//  ArrayExtensions.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import Foundation

public extension Array where Element == OptionalEntry {
    /// Chunk the array of `OptionalEntry` into an array of `EntryChunk`.
    ///
    /// ```
    /// let entries = [
    ///     OptionalEntry(x: 0, y: 0),
    ///     OptionalEntry(x: 1, y: nil),
    ///     OptionalEntry(x: 2, y: 2),
    ///     OptionalEntry(x: 3, y: 3),
    ///     OptionalEntry(x: 4, y: nil),
    /// ]
    /// 
    /// entries.chunked()
    /// // => [
    /// //     .entry([
    /// //         Entry(x: 0, y: 0),
    /// //     ]),
    /// //     .optionalEntry(xs: [1]),
    /// //     .entry([
    /// //         Entry(x: 2, y: 2),
    /// //         Entry(x: 3, y: 3),
    /// //     ]),
    /// //     .optionalEntry(xs: [4]),
    /// // ]
    /// ```
    ///
    /// - Returns: An array of `EntryChunk`.
    func chunked() -> [EntryChunk] {
        reduce(into: []) { result, entry in
            switch (entry.toEntry(), result.last) {
            case (let entry?, .entry(let last)):
                result[result.count - 1] = .entry(last + [entry])

            case (let entry?, _):
                result.append(.entry([entry]))

            case (nil, .optionalEntry(let xs)):
                result[result.count - 1] = .optionalEntry(xs: xs + [entry.x])

            case (nil, _):
                result.append(.optionalEntry(xs: [entry.x]))
            }
        }
    }

    /// Chunk the array of `OptionalEntry` into an nested array of `Entry` by
    /// unwrapping the optional `y` value.
    ///
    /// ```
    /// let entries = [
    ///     OptionalEntry(x: 0, y: 0),
    ///     OptionalEntry(x: 1, y: nil),
    ///     OptionalEntry(x: 2, y: 2),
    ///     OptionalEntry(x: 3, y: 3),
    ///     OptionalEntry(x: 4, y: nil),
    /// ]
    /// 
    /// entries.chunkedWithUnwrapping()
    /// // => [
    /// //     [
    /// //         Entry(x: 0, y: 0),
    /// //     ],
    /// //     [
    /// //         Entry(x: 2, y: 2),
    /// //         Entry(x: 3, y: 3),
    /// //     ],
    /// // ]
    /// ```
    ///
    /// - Returns: An chunked nested array of `Entry`.
    func chunkedWithUnwrapping() -> [[Entry]] {
        chunked().reduce([]) { result, chunk in
            guard case .entry(let entries) = chunk else {
                return result
            }

            return result + [entries]
        }
    }
}
