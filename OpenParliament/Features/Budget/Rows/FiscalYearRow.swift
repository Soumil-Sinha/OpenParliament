//
//  FiscalYearRow.swift
//  OpenParliament
//

import SwiftUI

/// Allocation and actual expenditure for a single financial year.
struct FiscalYearRow: View {
    let year: FiscalYearSpend

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(year.fullLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .monospacedDigit()
                Spacer(minLength: 12)
                Text(year.utilisation.percentWhole)
                    .font(.subheadline)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                Text(year.allocation.croreFormatted)
                    .monospacedDigit()
                Text("allocated")
                Text("·")
                Text(year.actual.croreFormatted)
                    .monospacedDigit()
                Text("spent")
            }
            .font(.caption)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ForEach(SampleData.schemes[0].years) { FiscalYearRow(year: $0) }
    }
    .listStyle(.plain)
}
