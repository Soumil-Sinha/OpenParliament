//
//  KeyValueRow.swift
//  OpenParliament
//

import SwiftUI

/// Label on the left, figure on the right, sharing one baseline.
struct KeyValueRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .font(.subheadline)
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: 8) {
        KeyValueRow(label: "Allocated, all schemes", value: "₹110,300 Cr")
        KeyValueRow(label: "Spent, all schemes", value: "₹93,870 Cr")
    }
    .padding()
}
