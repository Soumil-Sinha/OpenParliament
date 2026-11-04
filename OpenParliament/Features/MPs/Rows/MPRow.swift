//
//  MPRow.swift
//  OpenParliament
//

import SwiftUI

/// One member in the searchable members list.
struct MPRow: View {
    let mp: MP

    var body: some View {
        HStack(spacing: 13) {
            AvatarView(size: 38)

            VStack(alignment: .leading, spacing: 2) {
                Text(mp.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(mp.constituencyLine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(mp.party.abbreviation) · \(mp.house.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 8)

            AttendanceBadge(percent: mp.attendance)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    List {
        ForEach(SampleData.mps) { MPRow(mp: $0) }
    }
    .listStyle(.plain)
}
