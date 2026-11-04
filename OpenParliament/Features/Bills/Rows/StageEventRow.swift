//
//  StageEventRow.swift
//  OpenParliament
//

import SwiftUI

/// One dated step in the legislative timeline.
struct StageEventRow: View {
    let event: StageEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(event.stage.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer(minLength: 12)
                Text(event.date.mediumDay)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Text(event.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ForEach(SampleData.bills[2].stageHistory) { StageEventRow(event: $0) }
    }
    .listStyle(.plain)
}
