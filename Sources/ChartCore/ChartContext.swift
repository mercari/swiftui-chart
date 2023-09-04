//
//  ChartContext.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import CoreGraphics

/// A struct that contains the information needed to build a chart.
public struct ChartContext: Equatable {
    /// An array of `OptionalEntry` that represents the entries of the chart.
    public let entries: [OptionalEntry]
    /// The size of the `View` that the chart will be rendered in and will have 
    /// the coordinates of the chart.
    public let size: CGSize
    /// A `MatrixTransformer` that will be used to transform the coordinates
    /// between the chart entries and the `View` coordinates.
    public let transformer: MatrixTransformer

    internal init(
        entries: [OptionalEntry],
        size: CGSize,
        transformer: MatrixTransformer
    ) {
        self.entries = entries
        self.size = size
        self.transformer = transformer
    }
}

public extension ChartContext {
    /// Transform the entries in the chart context.
    ///
    /// - Parameter transform: A closure to transform an array of 
    ///   `OptionalEntry`.
    ///
    /// - Returns: A new chart context with the transformed entries.
    func transformEntries(_ transform: ([OptionalEntry]) -> [OptionalEntry]) -> ChartContext {
        ChartContext(
            entries: transform(entries),
            size: size,
            transformer: transformer
        )
    }
}
