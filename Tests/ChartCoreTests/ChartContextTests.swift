//
//  ChartContextTests.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import XCTest

@testable import ChartCore

final class ChartContextTests: XCTestCase {
    func testTranslate() throws {
        let translate = { (entries: [OptionalEntry]) in
            entries.map {
                OptionalEntry(x: $0.x, y: $0.y.map { $0 + 100 })
            }
        }

        XCTAssertEqual(
            makeContext([]).transformEntries(translate),
            makeContext([])
        )
        XCTAssertEqual(
            makeContext([
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: 100),
                OptionalEntry(x: 2, y: nil),
            ])
            .transformEntries(translate),
            makeContext([
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ])
        )
        XCTAssertEqual(
            makeContext([
                OptionalEntry(x: 0, y: 0),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: 2),
                OptionalEntry(x: 3, y: 3),
                OptionalEntry(x: 4, y: nil),
            ])
            .transformEntries(translate),
            makeContext([
                OptionalEntry(x: 0, y: 100),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: 102),
                OptionalEntry(x: 3, y: 103),
                OptionalEntry(x: 4, y: nil),
            ])
        )
    }
}

private extension ChartContextTests {
    func makeContext(_ entries: [OptionalEntry]) -> ChartContext {
        ChartContext(
            entries: entries,
            size: .zero,
            transformer: MatrixTransformer(
                xMin: 0,
                xMax: 100,
                yMin: 20,
                yMax: 300,
                size: .zero
            )
        )
    }
}
