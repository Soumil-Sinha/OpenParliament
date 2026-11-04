//
//  SchemeRow.swift
//  OpenParliament
//

import SwiftUI

/// One scheme in the budget list.
struct SchemeRow: View {
    let scheme: BudgetScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(scheme.sector.uppercased())
                .font(.caption2)
                .fontWeight(.medium)
                .tracking(0.6)
                .foregroundStyle(.tertiary)

            Text(scheme.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Text(scheme.totalAllocation.croreFormatted)
                    .monospacedDigit()
                Text("allocated")
                Text("·")
                Text(scheme.totalActual.croreFormatted)
                    .monospacedDigit()
                Text("spent")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                UtilisationBar(fraction: scheme.utilisation / 100)
                Text(scheme.utilisation.percentWhole)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                if scheme.cagFinding != nil {
                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .accessibilityLabel("Has an audit observation")
                }
            }
            .padding(.top, 1)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        ForEach(SampleData.schemes) { SchemeRow(scheme: $0) }
    }
    .listStyle(.plain)
}
