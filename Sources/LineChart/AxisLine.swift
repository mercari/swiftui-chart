//
//  AxisLine.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A shape that draws the horizontal lines of the chart.
public struct XAxisLine: Shape {
    private let context: ChartContext
    private let ys: [Double]

    /// Creates an instance that draws the horizontal lines of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - ys: The y values of the horizontal lines.
    public init(
        context: ChartContext,
        ys: [Double]
    ) {
        self.context = context
        self.ys = ys
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            for y in ys {
                let yy = context.transformer.toChartSpace(y: y)
                path.move(to: CGPoint(x: 0, y: yy))
                path.addLine(to: CGPoint(x: context.size.width, y: yy))
            }
        }
    }
}
