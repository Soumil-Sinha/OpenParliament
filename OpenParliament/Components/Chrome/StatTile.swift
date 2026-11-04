//
//  StatTile.swift
//  OpenParliament
//

import SwiftUI

/// One figure in a row of headline numbers. `emphasized` promotes the value to
/// the accent colour — reserved for the single key metric on a screen.
struct StatTile: View {
    let value: String
    let label: String
    var emphasized: Bool = false
    var caption: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundStyle(emphasized ? Theme.accent : Color.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if let caption {
                Text(caption)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

/// Row of statistics, evenly divided.
struct StatRow<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            content
        }
    }
}

#Preview {
    StatRow {
        StatTile(value: "92%", label: "Attendance", emphasized: true, caption: "7 sessions")
        StatTile(value: "+1.0 pts", label: "Since Budget 2022")
        StatTile(value: "214", label: "Questions asked", caption: "Since 2014")
    }
    .padding()
}
