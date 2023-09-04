//
//  SmoothChart.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore
import LineChart

struct SmoothChart: View {
    @State
    private var smoothingRange = 3
    @State
    private var showsOriginal = false
    @State
    private var showsPoints = true

    var body: some View {
        VStack(alignment: .leading) {
            chart

            Divider()
                .padding(.vertical)

            HStack {
                Text("Smoothing Range:")
                Slider(
                    value: Binding(
                        get: { Double(smoothingRange) },
                        set: { smoothingRange = Int($0) }
                    ),
                    in: 3...9,
                    step: 2
                )
                Text("\(smoothingRange)")
            }

            Toggle("Show Original:", isOn: $showsOriginal)
            Toggle("Show Points:", isOn: $showsPoints)

            Spacer()
        }
        .padding()
        .navigationTitle("Smoothing")
    }

    var chart: some View {
        LineChart(SampleData.entries) { context in
            ZStack {
                if showsOriginal {
                    SplineLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(Color.orange.opacity(0.7))

                    if showsPoints {
                        Point(context: context, radius: 3)
                            .fill(Color.orange.opacity(0.7))
                    }
                }

                let calculator = MovingAverageCalculator(range: smoothingRange)
                let transformed = context.transformEntries { calculator($0) }
                SplineLine(context: transformed)
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .fill(Color.orange)

                if showsPoints {
                    Point(context: transformed, radius: 3)
                    .fill(Color.orange)
                }
            }
            .frame(height: 200)
            .markAsChartContent()
        }
        .chartScale(y: 0.8)
    }
}
