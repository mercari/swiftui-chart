//
//  Axes.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A view that draws the axes of the chart.
public struct Axes<Content: View, XLabel: View, YLabel: View>: View {
    private let context: ChartContext
    private var showsXAxis = true
    private var xs: [Double]?
    private let xLabel: (Double) -> XLabel
    private var showsYAxis = true
    private var ys: [Double]?
    private let yLabel: (Double) -> YLabel
    private let content: () -> Content

    /// Creates an instance that draws the axes of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - xLabel: A closure that will be called to build the label of X-axis.
    ///   - yLabel: A closure that will be called to build the label of Y-axis.
    ///   - content: A closure that will be called to build the chart.
    public init(
        context: ChartContext,
        xLabel: @escaping (Double) -> XLabel = {
            Text("\($0)")
        },
        yLabel: @escaping (Double) -> YLabel = {
            Text("\($0)")
        },
        content: @escaping () -> Content
    ) {
        self.context = context
        self.xLabel = xLabel
        self.yLabel = yLabel
        self.content = content
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    if showsYAxis {
                        yAxis
                    }

                    content().hidden()
                }

                if showsXAxis {
                    xAxis.hidden()
                }
            }

            HStack(alignment: .top) {
                if showsYAxis {
                    yAxis.hidden()
                }

                VStack(alignment: .leading) {
                    content()

                    if showsXAxis {
                        xAxis
                    }
                }
            }
        }
    }

    /// Set whether the X-axis is shown.
    public func xAxis(_ enabled: Bool) -> Self {
        var view = self
        view.showsXAxis = enabled

        return view
    }

    /// Set the values indicating where the labels of X-axis will be shown.
    public func xAxisValues(_ values: [Double]?) -> Self {
        var view = self
        view.xs = values

        return view
    }

    /// Set whether the Y-axis is shown.
    public func yAxis(_ enabled: Bool) -> Self {
        var view = self
        view.showsYAxis = enabled

        return view
    }

    /// Set the values indicating where the labels of Y-axis will be shown.
    public func yAxisValues(_ values: [Double]?) -> Self {
        var view = self
        view.ys = values

        return view
    }

    private var xAxis: some View {
        XAxis(context: context, label: xLabel)
            .values(xs)
    }

    private var yAxis: some View {
        YAxis(context: context, label: yLabel)
            .values(ys)
    }

    private var cornerSpacer: some View {
        ZStack {
            xAxis.frame(width: 1)
            yAxis.frame(height: 1)
        }
        .hidden()
    }
}

/// A view that draws the X-axis of the chart.
public struct XAxis<Label: View>: View {
    private let context: ChartContext
    private var xs: [Double]?
    private let label: (Double) -> Label

    /// Creates an instance that draws the X-axis of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - label: A closure that will be called to build the label of X-axis.
    public init(
        context: ChartContext,
        label: @escaping (Double) -> Label
    ) {
        self.context = context
        self.label = label
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            ForEach(xValues, id: \.self) { value in
                label(value)
                    .offset(x: context.transformer.toChartSpace(x: value))
            }
        }
    }

    /// Set the values indicating where the labels of X-axis will be shown.
    ///
    /// If `nil` is specified, the values will be calculated automatically.
    public func values(_ values: [Double]?) -> Self {
        var view = self
        view.xs = values

        return view
    }

    private var xValues: [Double] {
        if let xs {
            return xs
        }

        let span = (context.transformer.xMax - context.transformer.xMin) / 10

        let left = stride(from: context.transformer.xMid, through: context.transformer.xMin, by: -span).reversed()
        let right = stride(from: context.transformer.xMid, through: context.transformer.xMax, by: span)
        return left + right.dropFirst().dropLast()
    }
}

/// A view that draws the Y-axis of the chart.
public struct YAxis<Label: View>: View {
    private let context: ChartContext
    private var ys: [Double]?
    private let label: (Double) -> Label

    /// Creates an instance that draws the Y-axis of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - label: A closure that will be called to build the label of Y-axis.
    public init(
        context: ChartContext,
        label: @escaping (Double) -> Label
    ) {
        self.context = context
        self.label = label
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ForEach(yValues, id: \.self) { value in
                label(value)
                    .offset(y: context.transformer.toChartSpace(y: value))
            }
        }
    }

    /// Set the values indicating where the labels of Y-axis will be shown.
    ///
    /// If `nil` is specified, the values will be calculated automatically.
    public func values(_ values: [Double]?) -> Self {
        var view = self
        view.ys = values

        return view
    }

    private var yValues: [Double] {
        if let ys {
            return ys
        }

        let span = (context.transformer.yMax - context.transformer.yMin) / 10

        let left = stride(from: context.transformer.yMid, through: context.transformer.yMin, by: -span).reversed()
        let right = stride(from: context.transformer.yMid, through: context.transformer.yMax, by: span)
        return left + right.dropFirst().dropLast()
    }
}
