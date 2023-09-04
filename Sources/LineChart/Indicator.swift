//
//  Indicator.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A shape that draws the indicator of the chart.
public struct Indicator: Shape {
    /// The axis of the indicator.
    public struct Axis: OptionSet {
        public let rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let x = Axis(rawValue: 1 << 0)
        public static let y = Axis(rawValue: 1 << 1)

        public static let both: Axis = [.x, .y]
    }

    private let context: ChartContext
    private let selected: OptionalEntry?
    private let axis: Axis

    /// Creates an instance that draws the indicator of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - selected: The selected entry.
    ///   - axis: The axis to draw the lines.
    public init(
        context: ChartContext,
        selected: OptionalEntry?,
        axis: Axis = .y
    ) {
        self.context = context
        self.selected = selected
        self.axis = axis
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            guard let selected else {
                return
            }

            if axis.contains(.x),
               let y = selected.y {
                let py = context.transformer.toChartSpace(y: y)
                path.move(to: CGPoint(x: 0, y: py))
                path.addLine(to: CGPoint(x: context.size.width, y: py))
            }

            if axis.contains(.y) {
                let px = context.transformer.toChartSpace(x: selected.x)
                path.move(to: CGPoint(x: px, y: 0))
                path.addLine(to: CGPoint(x: px, y: context.size.height))
            }
        }
    }
}
