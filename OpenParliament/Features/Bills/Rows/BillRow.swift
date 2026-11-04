//
//  BillRow.swift
//  OpenParliament
//

import SwiftUI

/// One bill in the bills list.
struct BillRow: View {
    let bill: Bill
    @Environment(ParliamentStore.self) private var store

    private var speakerCount: Int {
        store.speakers(onBill: bill.id).count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bill.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(bill.referenceLine)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                StageChip(stage: bill.stage)

                if let latest = bill.latestEvent {
                    Text(latest.date.monthYear)
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundStyle(.tertiary)
                }

                Text("\(speakerCount) spoke")
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
            }
            .padding(.top, 1)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        ForEach(SampleData.bills) { BillRow(bill: $0) }
    }
    .listStyle(.plain)
    .environment(ParliamentStore.preview)
}
