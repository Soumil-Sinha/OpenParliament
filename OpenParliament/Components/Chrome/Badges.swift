//
//  Badges.swift
//  OpenParliament
//
//  Small capsule labels. Only `StageChip` carries any colour, and only to mark
//  where a bill currently stands.
//

import SwiftUI

/// Attendance percentage. Deliberately grayscale — the section footer explains
/// what the number covers.
struct AttendanceBadge: View {
    let percent: Double

    var body: some View {
        Text(percent.percentWhole)
            .font(.caption)
            .monospacedDigit()
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
                Capsule().strokeBorder(Theme.hairline, lineWidth: 0.7)
            }
            .accessibilityLabel("Attendance \(Int(percent.rounded())) percent")
    }
}

/// Compact stage marker used in the bills list.
struct StageChip: View {
    let stage: BillStage

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Theme.accent)
                .frame(width: 5, height: 5)
            Text(stage.title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule().strokeBorder(Theme.hairline, lineWidth: 0.7)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Current stage, \(stage.title)")
    }
}

/// Plain text tag for party, role, sector and similar metadata.
struct MetaTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background {
                Capsule().strokeBorder(Theme.hairline, lineWidth: 0.7)
            }
    }
}

#Preview {
    HStack(spacing: 10) {
        AttendanceBadge(percent: 92.3)
        StageChip(stage: .committee)
        MetaTag(text: "UDF")
    }
    .padding()
}
