//
//  XAxisLabel.swift
//  Example
//
//  Created by andooown on 2023/08/30.
//

import SwiftUI

struct XAxisLabel: View {
    let x: Double

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Rectangle()
                .frame(width: 1, height: 20)

            Text("\(x, specifier: "%.0f")")
                .font(.caption)
        }
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
}

struct XAxisLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            XAxisLabel(x: 0)
            XAxisLabel(x: 12.345)
            XAxisLabel(x: 100)
        }
    }
}
