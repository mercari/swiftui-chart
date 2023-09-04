//
//  BezierLine.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A shape that draws the lines of the chart which is interpolated by Bezier 
/// curve.
public struct BezierLine: Shape {
    private let context: ChartContext
    private let fill: Bool

    /// Creates an instance that draws the lines of the chart.
    ///
    /// ```
    /// BezierLine(context: context)
    ///     .stroke(Color.red, lineWidth: 2)
    /// ```
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - fill: A Boolean value that indicates whether the shape should be
    ///     filled.
    public init(
        context: ChartContext,
        fill: Bool = false
    ) {
        self.context = context
        self.fill = fill
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            for chunk in context.entries.chunkedWithUnwrapping() {
                guard let first = chunk.first, chunk.count > 2 else {
                    continue
                }

                path.move(to: context.transformer.toChartSpace(first))
                for (previous, current) in zip(chunk.dropLast(), chunk.dropFirst()) {
                    let pre = context.transformer.toChartSpace(previous)
                    let cur = context.transformer.toChartSpace(current)
                    let controlPointX = CGFloat(pre.x + (cur.x - pre.x) / 2.0)
                    path.addCurve(
                        to: cur,
                        control1: CGPoint(
                            x: controlPointX,
                            y: pre.y
                        ),
                        control2: CGPoint(
                            x: controlPointX,
                            y: cur.y
                        )
                    )
                }

                if fill, let last = chunk.last {
                    path.addLine(to: CGPoint(x: context.transformer.toChartSpace(x: last.x), y: context.size.height))
                    path.addLine(to: CGPoint(x: context.transformer.toChartSpace(x: first.x), y: context.size.height))
                    path.closeSubpath()
                }
            }
        }
    }
}
