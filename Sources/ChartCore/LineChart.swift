//
//  LineChart.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import Foundation
import SwiftUI

/// A container view that represents a line chart.
///
/// This is just a container view that will pass the chart context to the
/// content to build the chart.
public struct LineChart<Content: View>: View {
    private struct Configuration {
        /// Ratio indicating how much Y value will be plotted on Y-axis. 1.0
        /// means Y values will use all range on Y-axis.
        var yScale: Double
    }

    private let entries: [OptionalEntry]
    private let content: (ChartContext) -> Content
    private var config = Configuration(yScale: 1)

    @State
    private var size = CGSize.zero

    /// Creates a new line chart.
    ///
    /// ```
    /// LineChart(entries) { context in
    ///     LinearLine(context: context)
    ///         .stroke(Color.blue, style: StrokeStyle(lineWidth: 2))
    ///         .markAsChartContent()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - entries: An array of `OptionalEntry` that represents the entries of
    ///     the chart.
    ///   - content: A closure that will be called to build the chart. It should
    ///     return a `View` that contains the subview marked as chart content by
    ///     calling `markAsChartContent()`.
    public init(
        _ entries: [OptionalEntry],
        @ViewBuilder content: @escaping (ChartContext) -> Content
    ) {
        self.entries = entries
        self.content = content
    }

    public var body: some View {
        content(
            ChartContext(
                entries: entries,
                size: size,
                transformer: transformer(size: size)
            )
        )
        .onPreferenceChange(SizePreferenceKey.self) {
            size = $0
        }
    }

    /// Set the ratio indicating how much Y value will be plotted on Y-axis.
    /// 
    /// - Parameter y: 1.0 means Y values will use all range on Y-axis.
    public func chartScale(y: Double) -> Self {
        var view = self
        view.config.yScale = y

        return view
    }

    private func transformer(size: CGSize) -> MatrixTransformer {
        let xs = entries.map(\.x)
        let ys = entries.compactMap(\.y)

        return MatrixTransformer(
            xMin: xs.min() ?? 0,
            xMax: xs.max() ?? 0,
            yMin: ys.min() ?? 0,
            yMax: ys.max() ?? 0,
            yScale: config.yScale,
            size: size
        )
    }
}

public extension View {
    /// Mark the view as a chart content.
    func markAsChartContent() -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let size = nextValue()
        if size != .zero {
            value = size
        }
    }
}
