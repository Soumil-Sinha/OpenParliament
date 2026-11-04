//
//  BillEngagementRow.swift
//  OpenParliament
//

import SwiftUI

/// A bill a member is on the record for, with the capacity they acted in.
struct BillEngagementRow: View {
    let bill: Bill
    let role: EngagementRole

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bill.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Text(role.rawValue)
                    .font(.caption)
                    .fontWeight(role.isAuthorship ? .medium : .regular)
                    .foregroundStyle(.secondary)
                Text("·")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text(bill.stage.title)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        BillEngagementRow(bill: SampleData.bills[2], role: .sponsor)
        BillEngagementRow(bill: SampleData.bills[0], role: .committeeMember)
    }
    .listStyle(.plain)
}
