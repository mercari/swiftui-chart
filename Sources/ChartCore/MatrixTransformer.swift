//
//  MatrixTransformer.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import CoreGraphics

/// A struct that supports the transformation between the chart space and the
/// value space.
public struct MatrixTransformer: Equatable {
    /// The minimum value on X-axis.
    public let xMin: Double
    /// The maximum value on X-axis.
    public let xMax: Double
    /// The minimum value on Y-axis.
    public let yMin: Double
    /// The maximum value on Y-axis.
    public let yMax: Double
    /// Ratio indicating how much Y value will be plotted on Y-axis.
    public let yScale: Double
    /// The size of the `View` that the chart will be rendered in.
    public let size: CGSize

    internal init(
        xMin: Double,
        xMax: Double,
        yMin: Double,
        yMax: Double,
        yScale: Double = 1.0,
        size: CGSize
    ) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        self.yScale = yScale
        self.size = size
    }

    /// Transform the x value from the chart value coordinate to the `View`
    /// coordinate.
    public func toChartSpace(x: Double) -> CGFloat {
        xMax > xMin ? (x - xMin) / (xMax - xMin) * size.width : size.width / 2
    }

    /// Transform the y value from the chart value coordinate to the `View`
    /// coordinate.
    public func toChartSpace(y: Double) -> CGFloat {
        var py = yMax > yMin ? (1 - (y - yMin) / (yMax - yMin)) * size.height : size.height / 2

        // Scaling on Y-axis
        let mid = size.height / 2
        py = (py - mid) * yScale + mid

        return py
    }

    /// Transform the x value from the `View` coordinate to the chart value
    /// coordinate.
    public func toValueSpace(px: CGFloat) -> Double {
        guard size.width > 0 else {
            return 0
        }

        return xMax > xMin ? px / size.width * (xMax - xMin) + xMin : (xMax + xMin) / 2
    }

    /// Transform the y value from the `View` coordinate to the chart value
    /// coordinate.
    public func toValueSpace(py: CGFloat) -> Double {
        guard size.height > 0 else {
            return 0
        }

        // Scaling on Y-axis
        let mid = size.height / 2
        let pyy = (py - mid) / yScale + mid

        return yMax > yMin ? (1 - pyy / size.height) * (yMax - yMin) + yMin : (yMax - yMin) / 2
    }
}

public extension MatrixTransformer {
    /// The center value on X-axis.
    var xMid: CGFloat {
        (xMin + xMax) / 2
    }

    /// The center value on Y-axis.
    var yMid: CGFloat {
        (yMin + yMax) / 2
    }

    /// Transform the entry to the `View` coordinate point.
    func toChartSpace(_ entry: Entry) -> CGPoint {
        toChartSpace(x: entry.x, y: entry.y)
    }

    /// Transform the x and y value to the `View` coordinate point.
    func toChartSpace(x: Double, y: Double) -> CGPoint {
        CGPoint(x: toChartSpace(x: x), y: toChartSpace(y: y))
    }

    /// Transform the `View` coordinate point to the entry.
    func toValueSpace(p: CGPoint) -> Entry {
        toValueSpace(px: p.x, py: p.y)
    }

    /// Transform the `View` coordinate x and y value to the entry.
    func toValueSpace(px: CGFloat, py: CGFloat) -> Entry {
        Entry(
            x: toValueSpace(px: px),
            y: toValueSpace(py: py)
        )
    }
}
