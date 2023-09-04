//
//  FillChart.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore
import LineChart

struct FillChart: View {
    enum Variant: String, Hashable, CaseIterable {
        case line = "Not filled"
        case filled = "Filled"
        case gradient = "Filled by gradient"
        case gradientWithMask = "Filled by gradient with mask"
    }

    @State
    private var variant = Variant.filled
    @State
    private var gradientOverlaysLine = true
    @State
    private var showsPoints = false

    var body: some View {
        VStack(alignment: .leading) {
            chart

            Divider()
                .padding(.vertical)

            HStack {
                Text("Line Variants:")
                Spacer()
                Picker("", selection: $variant) {
                    ForEach(Variant.allCases, id: \.self) { value in
                        Text(value.rawValue)
                    }
                }
            }
            VStack {
                if [.gradient, .gradientWithMask].contains(variant) {
                    Toggle("Line Overlay:", isOn: $gradientOverlaysLine)
                }
            }
            .padding(.leading)

            Toggle("Show Points:", isOn: $showsPoints)

            Spacer()
        }
        .padding()
        .navigationTitle("Fill")
    }

    var chart: some View {
        LineChart(SampleData.entries) { context in
            ZStack {
                switch variant {
                case .line:
                    SplineLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .fill(Color.orange)

                case .filled:
                    SplineLine(context: context, fill: true)
                        .fill(Color.orange)

                case .gradient:
                    SplineLine(context: context, fill: true)
                        .fill(
                            LinearGradient(
                                colors: [.orange, .orange.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    if gradientOverlaysLine {
                        SplineLine(context: context)
                            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .fill(Color.orange)
                    }


                case .gradientWithMask:
                    LinearGradient(
                        colors: [.orange, .orange.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        SplineLine(context: context, fill: true)
                            .fill(Color.black)
                    )

                    if gradientOverlaysLine {
                        SplineLine(context: context)
                            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .fill(Color.orange)
                    }
                }

                if showsPoints {
                    Point(context: context, radius: 3)
                        .fill(Color.black)
                }
            }
            .frame(height: 200)
            .markAsChartContent()
        }
        .chartScale(y: 0.8)
    }
}
