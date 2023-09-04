//
//  InteractionChart.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore
import LineChart

struct InteractionChart: View {
    @State
    private var selected: OptionalEntry?
    @State
    private var showsX = true
    @State
    private var showsY = true
    @State
    private var showsPoints = true

    var body: some View {
        VStack(alignment: .leading) {
            chart

            Text("Selected: \(formattedSelection)")
                .frame(maxWidth: .infinity, alignment: .trailing)

            Divider()
                .padding(.vertical)

            Toggle("Show X:", isOn: $showsX)
            Toggle("Show Y:", isOn: $showsY)
            Toggle("Show Points:", isOn: $showsPoints)

            Spacer()
        }
        .padding()
        .navigationTitle("Interaction")
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
                    SplineLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .fill(Color.orange)

                    if showsPoints {
                        Point(context: context, radius: 3)
                            .fill(Color.black)
                    }

                    Indicator(context: context, selected: selected, axis: axis)
                        .stroke(lineWidth: 1)
                        .fill(Color.black)
                }
                .frame(height: 200)
                .overlay(GestureHandler(context: context, selected: $selected))
                .markAsChartContent()
            }
            .xAxis(true)
            .xAxisValues([0, 50])
            .yAxis(true)
            .yAxisValues([0, 50, 100])
        }
        .chartScale(y: 0.8)
    }

    private var formattedSelection: String {
        guard let selected else {
            return "nil"
        }

        return "x: \(String(format: "%.0f", selected.x)), y: \(selected.y.flatMap { String(String(format: "%.0f", $0)) } ?? "nil")"
    }

    private var axis: Indicator.Axis {
        var axis = Indicator.Axis()

        if showsX {
            axis.insert(.x)
        }
        if showsY {
            axis.insert(.y)
        }

        return axis
    }
}
