//
//  MatrixTransformerTests.swift
//  
//
//  Created by andooown on 2023/08/30.
//

import XCTest

@testable import ChartCore

final class MatrixTransformerTests: XCTestCase {
    func testToChartSpaceX() throws {
        let transformer = MatrixTransformer(
            xMin: 0,
            xMax: 10,
            yMin: 0,
            yMax: 20,
            yScale: 0.5,
            size: CGSize(width: 100, height: 100)
        )
        
        XCTAssertEqual(transformer.toChartSpace(x: 5), 50)
        XCTAssertEqual(transformer.toChartSpace(x: 7), 70)
    }

    func testToChartSpaceY() throws {
        let transformer = MatrixTransformer(
            xMin: 0,
            xMax: 10,
            yMin: 0,
            yMax: 20,
            yScale: 0.5,
            size: CGSize(width: 100, height: 100)
        )

        XCTAssertEqual(transformer.toChartSpace(y: 0), 75)
        XCTAssertEqual(transformer.toChartSpace(y: 10), 50)
        XCTAssertEqual(transformer.toChartSpace(y: 15), 37.5)
    }

    func testToValueSpacePX() throws {
        let transformer = MatrixTransformer(
            xMin: 0,
            xMax: 10,
            yMin: 0,
            yMax: 20,
            yScale: 0.5,
            size: CGSize(width: 100, height: 100)
        )

        XCTAssertEqual(transformer.toValueSpace(px: 50), 5)
        XCTAssertEqual(transformer.toValueSpace(px: 70), 7)
    }

    func testToValueSpacePY() throws {
        let transformer = MatrixTransformer(
            xMin: 0,
            xMax: 10,
            yMin: 0,
            yMax: 20,
            yScale: 0.5,
            size: CGSize(width: 100, height: 100)
        )

        XCTAssertEqual(transformer.toValueSpace(py: 75), 0)
        XCTAssertEqual(transformer.toValueSpace(py: 50), 10)
        XCTAssertEqual(transformer.toValueSpace(py: 37.5), 15)
    }
}
