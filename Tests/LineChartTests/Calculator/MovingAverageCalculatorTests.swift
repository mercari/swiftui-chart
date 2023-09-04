//
//  MovingAverageCalculatorTests.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import XCTest

@testable import ChartCore
@testable import LineChart

final class MovingAverageCalculatorTests: XCTestCase {
    func testCallAsFunction() throws {
        let calculator = MovingAverageCalculator(range: 3)

        XCTAssertEqual(calculator([]), [])
        XCTAssertEqual(
            calculator([
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
            ]),
            [
                OptionalEntry(x: 0, y: (1 + 1 + 2) / 3),
                OptionalEntry(x: 1, y: (1 + 2 + 4) / 3),
                OptionalEntry(x: 2, y: (2 + 4 + 4) / 3),
                OptionalEntry(x: 3, y: nil),
                OptionalEntry(x: 4, y: (8 + 8 + 0) / 3),
                OptionalEntry(x: 5, y: (8 + 0 + 5) / 3),
                OptionalEntry(x: 6, y: (0 + 5 + 1) / 3),
                OptionalEntry(x: 7, y: (5 + 1 + 1) / 3),
            ]
        )
    }
}
