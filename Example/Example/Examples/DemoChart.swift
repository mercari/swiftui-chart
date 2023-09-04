//
//  DemoChart.swift
//  Example
//
//  Created by andooown on 2023/08/30.
//

import SwiftUI
import ChartCore
import LineChart

struct DemoChart: View {
    @State
    private var selected: OptionalEntry?
    @State
    private var normalLineVariant = NormalLineVariant.spline
    @State
    private var normalLineWidth = 4.0
    @State
    private var detailLineWidth = 2.0
    @State
    private var isSmoothingEnabled = true
    @State
    private var smoothingRange = 21
    @State
    private var isAnimationEnabled = true
    @State
    private var animationDuration = 0.3
    @State
    private var indicatorWidth = CGFloat.zero

    var body: some View {
        VStack(alignment: .leading) {
            chart

            Divider()
                .padding(.vertical)

            ScrollView {
                HStack {
                    Text("Line when Inactive:")
                    Spacer()
                    Picker("", selection: $normalLineVariant) {
                        ForEach(NormalLineVariant.allCases, id: \.self) { value in
                            Text(value.rawValue)
                        }
                    }
                }

                Text("Line Width:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    HStack {
                        Text("Inactive:")
                        Slider(
                            value: $normalLineWidth,
                            in: 1...10,
                            step: 1
                        )
                        Text("\(normalLineWidth, specifier: "%.0f")")
                    }
                    HStack {
                        Text("Active:")
                        Slider(
                            value: $detailLineWidth,
                            in: 1...10,
                            step: 1
                        )
                        Text("\(detailLineWidth, specifier: "%.0f")")
                    }
                }
                .padding(.leading)

                Toggle("Smoothing when Inactive:", isOn: $isSmoothingEnabled)
                if isSmoothingEnabled {
                    HStack {
                        Text("Range:")
                        Slider(
                            value: Binding(
                                get: { Double(smoothingRange) },
                                set: { smoothingRange = Int($0) }
                            ),
                            in: 3...31,
                            step: 2
                        )
                        Text("\(smoothingRange)")
                    }
                    .padding(.leading)
                }

                Toggle("Animated Transition:", isOn: $isAnimationEnabled)
                if isAnimationEnabled {
                    HStack {
                        Text("Duration:")
                        Slider(value: $animationDuration, in: 0.1...1, step: 0.1)
                        Text("\(animationDuration, specifier: "%.1f")")
                    }
                    .padding(.leading)
                }

                Button("Reset") {
                    normalLineVariant = .spline
                    normalLineWidth = 4
                    detailLineWidth = 2
                    isSmoothingEnabled = true
                    smoothingRange = 21
                    isAnimationEnabled = true
                    animationDuration = 0.3
                }
                .padding(.top)

                Spacer()
            }
        }
        .padding()
        .navigationTitle("Demo")
    }

    private var chart: some View {
        LineChart(SampleData.entries2) { context in
            VStack(alignment: .leading) {
                selectedIndicator
                    .offset(x: indicatorViewOffset(context: context, indicatorWidth: indicatorWidth))

                ZStack {
                    LinearGradient(
                        colors: [.orange.opacity(0.7), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        AnimatableLine(
                            context: context,
                            fill: true,
                            normalVariant: normalLineVariant,
                            smootingRange: isSmoothingEnabled ? smoothingRange : nil,
                            ratio: selected == nil ? 0 : 1
                        )
                        .fill(Color.black)
                        .animation(animation, value: selected == nil)
                    )

                    AnimatableLine(
                        context: context,
                        fill: false,
                        normalVariant: normalLineVariant,
                        smootingRange: isSmoothingEnabled ? smoothingRange : nil,
                        ratio: selected == nil ? 0 : 1
                    )
                    .stroke(style: StrokeStyle(lineWidth: selected == nil ? normalLineWidth : detailLineWidth, lineCap: .round))
                    .fill(Color.orange)
                    .animation(animation, value: selected == nil)

                    Indicator(context: context, selected: selected, axis: .y)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2], dashPhase: 0))
                        .fill(Color.red)
                }
                .frame(height: 200)
                .overlay(GestureHandler(context: context, selected: $selected))
                .markAsChartContent()
            }
        }
        .chartScale(y: 0.8)
    }

    private var selectedIndicator: some View {
        Group {
            if let selected {
                VStack {
                    Text("x: \(String(format: "%.0f", selected.x))")
                    Text("y: \(selected.y.flatMap { String(format: "%.0f", $0) } ?? "nil")")
                }
            } else {
                VStack {
                    Text("x: 0")
                    Text("y: 0")
                }
                .hidden()
            }
        }
        .font(.caption)
        .foregroundColor(Color(uiColor: .secondaryLabel))
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: IndicatorWidthPreferenceKey.self, value: proxy.size.width)
            }
        )
        .onPreferenceChange(IndicatorWidthPreferenceKey.self) {
            indicatorWidth = $0
        }
    }

    private func indicatorViewOffset(context: ChartContext, indicatorWidth: CGFloat) -> CGFloat {
        guard let selected else {
            return .zero
        }

        let selectedX = context.transformer.toChartSpace(x: selected.x)
        return max(0, min(selectedX - indicatorWidth / 2, context.size.width - indicatorWidth))
    }

    var animation: Animation? {
        guard isAnimationEnabled else {
            return nil
        }

        return .easeInOut(duration: animationDuration)
    }
}

private enum NormalLineVariant: String, CaseIterable {
    case linear = "Linear"
    case bezier = "Bezier"
    case spline = "Spline"
}

private struct AnimatableLine: Shape {
    let context: ChartContext
    let fill: Bool
    let normalVariant: NormalLineVariant
    let smootingRange: Int?
    var ratio: Double

    var animatableData: Double {
        get { ratio }
        set { ratio = newValue }
    }

    func path(in rect: CGRect) -> Path {
        if ratio < 0.5 {
            switch normalVariant {
            case .linear:
                return LinearLine(context: mixedContext, fill: fill).path(in: rect)

            case .bezier:
                return BezierLine(context: mixedContext, fill: fill).path(in: rect)

            case .spline:
                return SplineLine(context: mixedContext, fill: fill).path(in: rect)
            }
        } else {
            return LinearLine(context: mixedContext, fill: fill).path(in: rect)
        }
    }

    var mixedContext: ChartContext {
        context.transformEntries { entries in
            let base: [OptionalEntry]
            if let smootingRange {
                base = MovingAverageCalculator(range: smootingRange)(entries)
            } else {
                base = entries
            }

            let detail = entries

            return MixedValueCalculator(ratio: ratio)(base, detail)
        }
    }
}

private struct IndicatorWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let size = nextValue()
        if size > .zero {
            value = size
        }
    }
}
