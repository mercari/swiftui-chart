//
//  YAxisLabel.swift
//  Example
//
//  Created by andooown on 2023/08/30.
//

import SwiftUI

struct YAxisLabel: View {
    private struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue = CGFloat.zero

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            let size = nextValue()
            if size != .zero {
                value = size
            }
        }
    }

    let y: Double

    @State
    private var textHeight = CGFloat.zero

    var body: some View {
        Text("\(y, specifier: "%.0f")")
            .font(.caption)
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .offset(y: -textHeight / 2)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(HeightPreferenceKey.self) {
                textHeight = $0
            }
    }
}

struct YAxisLabel_Previews: PreviewProvider {
    static var previews: some View {
        YAxisLabel(y: 12.345)
    }
}
