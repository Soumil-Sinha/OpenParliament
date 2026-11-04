//
//  SpeechRow.swift
//  OpenParliament
//

import SwiftUI

/// One intervention: topic, a line of what was said, and when.
struct SpeechRow: View {
    let speech: Speech
    var isOnBill: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(speech.topic)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(speech.excerpt)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Text(speech.date.mediumDay)
                    .monospacedDigit()
                Text("·")
                Text("\(speech.durationMinutes) min")
                    .monospacedDigit()
                if isOnBill {
                    Text("·")
                    Text("On a bill")
                }
            }
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        SpeechRow(speech: SampleData.speeches[0], isOnBill: true)
        SpeechRow(speech: SampleData.speeches[14])
    }
    .listStyle(.plain)
}
