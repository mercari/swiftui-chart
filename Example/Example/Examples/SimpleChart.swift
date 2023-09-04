//
//  SimpleChart.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore
import LineChart

struct SimpleChart: View {
    @State
    private var lineWidth: CGFloat = 1
    @State
    private var pointRadius: CGFloat = 3
    @State
    private var color = Color.orange
    @State
    private var showXAxis = true
    @State
    private var showYAxis = true
    @State
    private var showXAxisLines = true

    var body: some View {
        VStack {
            chart

            Divider()
                .padding(.vertical)

            HStack {
                Text("Line Width:")
                Slider(value: $lineWidth, in: 1...10, step: 1)
                Text("\(lineWidth, specifier: "%.0f")")
            }

            HStack {
                Text("Point Radius:")
                Slider(value: $pointRadius, in: 0...10, step: 1)
                Text("\(pointRadius, specifier: "%.0f")")
            }

            ColorPicker("Line Color:", selection: $color)

            Toggle("X Axis:", isOn: $showXAxis)
            Toggle("Y Axis:", isOn: $showYAxis)

            Toggle("X Axis Lines:", isOn: $showXAxisLines)

            Spacer()
        }
        .padding()
        .navigationTitle("Simple Chart")
    }

    var chart: some View {
        LineChart(SampleData.entries) { context in
            Axes(
                context: context,
                xLabel: { value in
                    XAxisLabel(x: value)
                },
                yLabel: { value in
                    YAxisLabel(y: value)
                }
            ) {
                ZStack {
                    if showXAxisLines {
                        XAxisLine(context: context, ys: [0, 50, 100])
                            .stroke(lineWidth: 1)
                            .fill(Color(uiColor: .secondaryLabel))
                    }

                    LinearLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .fill(color)

                    Point(context: context, radius: pointRadius)
                        .fill(color)
                }
                .frame(height: 200)
                .border(Color(uiColor: .secondaryLabel), width: 1)
                .markAsChartContent()
            }
            .xAxis(showXAxis)
            .xAxisValues([0, 50])
            .yAxis(showYAxis)
            .yAxisValues([0, 50, 100])
        }
        .chartScale(y: 0.8)
    }
}
