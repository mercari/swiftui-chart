//
//  LinesDemoChart.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore
import LineChart

struct LinesChart: View {
    enum LineVariant: String, CaseIterable {
        case linear = "Linear"
        case bezier = "Bezier"
        case spline = "Spline"

        var color: Color {
            switch self {
            case .linear:
                return .red

            case .bezier:
                return .green

            case .spline:
                return .blue
            }
        }
    }

    @State
    private var selectedVariants = Set(LineVariant.allCases)
    @State
    private var showsPoints = true

    var body: some View {
        VStack(alignment: .leading) {
            chart

            Divider()
                .padding(.vertical)

            Text("Line Variants:")
            ForEach(LineVariant.allCases, id: \.self) { value in
                HStack {
                    Toggle(
                        isOn: Binding(
                            get: { selectedVariants.contains(value) },
                            set: {
                                if $0 {
                                    selectedVariants.insert(value)
                                } else {
                                    selectedVariants.remove(value)
                                }
                            }
                        )
                    ) {
                        HStack {
                            Rectangle()
                                .fill(value.color)
                                .frame(width: 16, height: 16)
                            Text("\(value.rawValue):")
                        }
                    }

                    Button("Only", action: {
                        selectedVariants = [value]
                    })
                }
                .padding(.leading)
            }

            Toggle("Show Points:", isOn: $showsPoints)

            Spacer()
        }
        .padding()
        .navigationTitle("Lines")
    }

    var chart: some View {
        LineChart(SampleData.entries) { context in
            ZStack {
                if selectedVariants.contains(.linear) {
                    LinearLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(LineVariant.linear.color)
                }
                if selectedVariants.contains(.bezier) {
                    BezierLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(LineVariant.bezier.color)
                }
                if selectedVariants.contains(.spline) {
                    SplineLine(context: context)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .fill(LineVariant.spline.color)
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
