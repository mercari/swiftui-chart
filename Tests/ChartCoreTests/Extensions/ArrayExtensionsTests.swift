//
//  ArrayExtensionsTests.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import XCTest

@testable import ChartCore

final class EntryTests: XCTestCase {
    func testArrayChunked() throws {
        XCTAssertEqual([].chunked(), [])
        XCTAssertEqual(
            [
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ].chunked(),
            [
                .optionalEntry(xs: [0, 1, 2]),
            ]
        )
        XCTAssertEqual(
            [
                OptionalEntry(x: 0, y: 0),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: 2),
                OptionalEntry(x: 3, y: 3),
                OptionalEntry(x: 4, y: nil),
            ].chunked(),
            [
                .entry([
                    Entry(x: 0, y: 0),
                ]),
                .optionalEntry(xs: [1]),
                .entry([
                    Entry(x: 2, y: 2),
                    Entry(x: 3, y: 3),
                ]),
                .optionalEntry(xs: [4]),
            ]
        )
    }

    func testArrayChunkedWithUnwrapping() throws {
        XCTAssertEqual([].chunkedWithUnwrapping(), [])
        XCTAssertEqual(
            [
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ].chunkedWithUnwrapping(),
            []
        )
        XCTAssertEqual(
            [
                OptionalEntry(x: 0, y: 0),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: 2),
                OptionalEntry(x: 3, y: 3),
                OptionalEntry(x: 4, y: nil),
            ].chunkedWithUnwrapping(),
            [
                [
                    Entry(x: 0, y: 0),
                ],
                [
                    Entry(x: 2, y: 2),
                    Entry(x: 3, y: 3),
                ],
            ]
        )
    }
}
