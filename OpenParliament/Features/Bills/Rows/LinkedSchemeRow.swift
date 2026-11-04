//
//  LinkedSchemeRow.swift
//  OpenParliament
//

import SwiftUI

/// A scheme referenced from a bill, with the money attached to it.
struct LinkedSchemeRow: View {
    let scheme: BudgetScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(scheme.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(scheme.sector)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 6) {
                Text(scheme.totalAllocation.croreFormatted)
                    .monospacedDigit()
                Text("allocated ·")
                Text(scheme.utilisation.percentWhole)
                    .monospacedDigit()
                Text("utilised")
            }
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ForEach(SampleData.schemes) { LinkedSchemeRow(scheme: $0) }
    }
    .listStyle(.plain)
}
