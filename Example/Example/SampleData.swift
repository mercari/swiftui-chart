//
//  SampleData.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import Foundation
import ChartCore

enum SampleData {
    static let entries = [
        10,
        50,
        30,
        40,
        120,
        nil,
        100,
        30,
        -20,
        90,
        70,
    ]
    .enumerated()
    .map { OptionalEntry(x: Double($0.offset * 10), y: $0.element) }

    static let entries2 = {
        let mid = 50.0
        let size = 50.0
        let count = 100.0

        return stride(from: 0, to: count, by: 1.0).map { x in
            guard !(count * 0.2..<count * 0.3).contains(x) else {
                return OptionalEntry(x: x, y: nil)
            }

            let y =
                size * sin(x * 2 * Double.pi / count)
                + 0.8 * size * cos(x * 2 * Double.pi / count * 2)
                + 0.2 * size * cos(x * 2)
                + mid
            return OptionalEntry(x: x, y: y)
        }
    }()
}
