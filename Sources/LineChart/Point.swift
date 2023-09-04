//
//  Point.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A shape that draws the points of the chart.
public struct Point: Shape {
    private let context: ChartContext
    private let radius: CGFloat

    /// Creates an instance that draws the points of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - radius: The radius of the points.
    public init(
        context: ChartContext,
        radius: CGFloat = 3
    ) {
        self.context = context
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            for entry in context.entries {
                guard let entry = entry.toEntry() else {
                    continue
                }

                let point = context.transformer.toChartSpace(entry)
                let rect = CGRect(origin: point, size: .zero).insetBy(dx: -radius, dy: -radius)
                path.addEllipse(in: rect)
            }
        }
    }
}
