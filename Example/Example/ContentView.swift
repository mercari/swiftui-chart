//
//  ContentView.swift
//  Example
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

struct ContentView: View {
    enum Destination: Hashable {
        case simple
        case lines
        case fill
        case interaction
        case smooth
        case animation
        case demo
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Basic") {
                    NavigationLink("Simple Chart", value: Destination.simple)
                    NavigationLink("Lines", value: Destination.lines)
                    NavigationLink("Fill", value: Destination.fill)
                    NavigationLink("Interaction", value: Destination.interaction)
                    NavigationLink("Smoothing", value: Destination.smooth)
                    NavigationLink("Animation", value: Destination.animation)
                }
                Section("Advanced") {
                    NavigationLink("Demo", value: Destination.demo)
                }
            }
            .navigationTitle("Example")
            .navigationDestination(for: Destination.self) {
                switch $0 {
                case .simple:
                    SimpleChart()

                case .lines:
                    LinesChart()

                case .fill:
                    FillChart()

                case .interaction:
                    InteractionChart()

                case .smooth:
                    SmoothChart()

                case .animation:
                    AnimationChart()

                case .demo:
                    DemoChart()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
