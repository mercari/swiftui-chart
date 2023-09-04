//
//  ChartGestureHandler.swift
//  
//
//  Created by andooown on 2023/08/29.
//

import SwiftUI
import ChartCore

/// A view that handles the common gestures of the chart.
public struct GestureHandler: View {
    private enum ChartGestureState: Equatable {
        case inactive
        case waitingForLongTap(CGPoint)
        case longTapBegin(CGPoint?)
        case longTapping(CGPoint)

        var location: CGPoint? {
            switch self {
            case .longTapBegin(let location?), .longTapping(let location):
                return location

            default:
                return nil
            }
        }

        mutating func beginTap() {
            switch self {
            case .inactive:
                self = .longTapBegin(nil)

            case .waitingForLongTap(let location):
                self = .longTapBegin(location)

            case .longTapBegin,
                .longTapping:
                break
            }
        }

        mutating func locationChanged(_ location: CGPoint) {
            switch self {
            case .inactive:
                self = .waitingForLongTap(location)

            case .waitingForLongTap(let current):
                if current != location {
                    self = .longTapBegin(location)
                }
                else {
                    self = .waitingForLongTap(location)
                }

            case .longTapBegin,
                .longTapping:
                self = .longTapping(location)
            }
        }
    }

    private let context: ChartContext
    @Binding
    private var selected: OptionalEntry?

    @State
    private var state: ChartGestureState = .inactive {
        didSet {
            let entry = state.location.flatMap { location -> OptionalEntry? in
                // Search nearest entry
                let x = context.transformer.toValueSpace(px: location.x)
                return context.entries.min { lhs, rhs in
                    let lDist = abs(lhs.x - x)
                    let rDist = abs(rhs.x - x)

                    return lDist < rDist
                }
            }

            if entry != selected {
                selected = entry
            }
        }
    }

    /// Creates an instance that handles the common gestures of the chart.
    ///
    /// - Parameters:
    ///   - context: The context of the chart.
    ///   - selected: The selected entry which is updated from user interaction.
    public init(
        context: ChartContext,
        selected: Binding<OptionalEntry?>
    ) {
        self.context = context
        self._selected = selected
    }

    public var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(gesture)
    }

    private var gesture: some Gesture {
        let longPress = LongPressGesture()
            .onEnded { _ in
                state.beginTap()
            }
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { value in
                state.locationChanged(value.location)
            }
        return
            longPress
            .simultaneously(with: drag)
            .onEnded { _ in
                state = .inactive
            }
    }
}
