//
//  AnimationChart.swift
//  Example
//
//  Created by andooown on 2023/08/30.
//

import SwiftUI
import ChartCore
import LineChart

struct AnimationChart: View {
    @State
    private var showsDetail = false
    @State
    private var showsPoints = true

    var body: some View {
        VStack(alignment: .leading) {
            AnimatableChart(
                entries: SampleData.entries,
                showsPoints: showsPoints,
                ratio: showsDetail ? 1 : 0
            )

            Divider()
                .padding(.vertical)

            Button("Toggle", action: {
                withAnimation {
                    showsDetail.toggle()
                }
            })
            .frame(maxWidth: .infinity)

            Toggle("Show Points:", isOn: $showsPoints)

            Spacer()
        }
        .padding()
        .navigationTitle("Animation")
    }
}

private struct AnimatableChart: View, Animatable {
    let entries: [OptionalEntry]
    let showsPoints: Bool
    var ratio: Double

    var animatableData: Double {
        get { ratio }
        set { ratio = newValue }
    }

    var body: some View {
        LineChart(entries) { context in
            let mixed = mixedContext(context)

            ZStack {
                if ratio < 0.5 {
                    SplineLine(context: mixed)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(Color.orange)
                } else {
                    LinearLine(context: mixed)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(Color.orange)
                }

                if showsPoints {
                    Point(context: mixed, radius: 3)
                        .fill(Color.orange)
                }
            }
            .frame(height: 200)
            .markAsChartContent()
        }
        .chartScale(y: 0.8)
    }

    func mixedContext(_ context: ChartContext) -> ChartContext {
        context.transformEntries { entries in
            let base = MovingAverageCalculator(range: 3)(entries)
            let detail = entries

            return MixedValueCalculator(ratio: ratio)(base, detail)
        }
    }
}
