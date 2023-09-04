//
//  MixedValueCalculatorTests.swift
//  
//
//  Created by andooown on 2023/08/30.
//

import XCTest

@testable import ChartCore
@testable import LineChart

final class MixedValueCalculatorTests: XCTestCase {
    func testCallAsFunction() throws {
        let calculator = MixedValueCalculator(ratio: 0.3)

        XCTAssertEqual(calculator([], []), [])
        XCTAssertEqual(
            calculator([
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ], [
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ]),
            [
                OptionalEntry(x: 0, y: nil),
                OptionalEntry(x: 1, y: nil),
                OptionalEntry(x: 2, y: nil),
            ]
        )
        XCTAssertEqual(
            calculator([
                OptionalEntry(x: 0, y: 1),
                OptionalEntry(x: 1, y: 2),
                OptionalEntry(x: 2, y: 4),
                OptionalEntry(x: 3, y: nil),
                OptionalEntry(x: 4, y: 8),
                OptionalEntry(x: 5, y: 0),
                OptionalEntry(x: 6, y: 5),
                OptionalEntry(x: 7, y: 1),
            ], [
                OptionalEntry(x: 0, y: 1),
                OptionalEntry(x: 1, y: 2),
                OptionalEntry(x: 2, y: 4),
                OptionalEntry(x: 3, y: nil),
                OptionalEntry(x: 4, y: 8),
                OptionalEntry(x: 5, y: 0),
                OptionalEntry(x: 6, y: 5),
                OptionalEntry(x: 7, y: 1),
            ]),
            [
                OptionalEntry(x: 0, y: 1),
                OptionalEntry(x: 1, y: 2),
                OptionalEntry(x: 2, y: 4),
                OptionalEntry(x: 3, y: nil),
                OptionalEntry(x: 4, y: 8),
                OptionalEntry(x: 5, y: 0),
                OptionalEntry(x: 6, y: 5),
                OptionalEntry(x: 7, y: 1),
            ]
        )
    }
}
