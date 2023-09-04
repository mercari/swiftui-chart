//
//  SplineLine.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A shape that draws the lines of the chart with cubic spline.
public struct SplineLine: Shape {
    private let context: ChartContext
    private let fill: Bool

    /// Creates an instance that draws the lines of the chart.
    ///
    /// ```
    /// SplineLine(context: context)
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
                guard chunk.count > 2 else {
                    continue
                }

                var h = [Double]()  // span of each x values
                var d = [Double]()  // y' = f'(x)
                var d2 = [Double]()  // y'' = f''(x)
                for i in chunk.indices {
                    if i == 0 {
                        h.append(0)
                        d.append(0)
                    }
                    else {
                        h.append(chunk[i].x - chunk[i - 1].x)
                        d.append((chunk[i].y - chunk[i - 1].y) / h[i])
                    }
                }
                for i in chunk.indices {
                    if i == 0 || i == chunk.count - 1 {
                        d2.append(0)
                    }
                    else {
                        d2.append((d[i + 1] - d[i]) / (chunk[i + 1].x - chunk[i - 1].x))
                    }
                }

                path.move(to: context.transformer.toChartSpace(chunk[0]))
                for i in chunk.indices.dropFirst() {
                    let previous = chunk[i - 1]
                    let current = chunk[i]

                    if previous.x < current.x {
                        // Interpolate between two points by 10 linear lines with cubic spline
                        let span = max((current.x - previous.x) / 10, 1)
                        for x in stride(from: previous.x, to: current.x, by: span) {
                            // a = f''(x_i-1) / (6 * h_i) * (x_i - x) ^ 3
                            let a = d2[i - 1] / (6 * h[i]) * (current.x - x) * (current.x - x) * (current.x - x)
                            // b = f''(x_i) / (6 * h_i) * (x - x_i-1) ^ 3
                            let b = d2[i] / (6 * h[i]) * (x - previous.x) * (x - previous.x) * (x - previous.x)
                            // c = (y_i-1 / h_i - (h_i * f''(x_i-1)) / 6) * (x_i - x)
                            let c = (previous.y / h[i] - h[i] * d2[i - 1] / 6) * (current.x - x)
                            // d = (y_i / h_i - (h_i * f''(x_i)) / 6) * (x - x_i-1)
                            let d = (current.y / h[i] - h[i] * d2[i] / 6) * (x - previous.x)
                            let y = a + b + c + d
                            path.addLine(to: context.transformer.toChartSpace(x: x, y: y))
                        }
                    }

                    path.addLine(to: context.transformer.toChartSpace(current))
                }

                if fill, let first = chunk.first, let last = chunk.last {
                    path.addLine(to: CGPoint(x: context.transformer.toChartSpace(x: last.x), y: context.size.height))
                    path.addLine(to: CGPoint(x: context.transformer.toChartSpace(x: first.x), y: context.size.height))
                    path.closeSubpath()
                }
            }
        }
    }
}
