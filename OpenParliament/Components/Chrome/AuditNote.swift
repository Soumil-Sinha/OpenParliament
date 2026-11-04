//
//  AuditNote.swift
//  OpenParliament
//

import SwiftUI

/// Neutral gray note for a CAG finding. Intentionally not styled as a warning:
/// an audit observation is a fact on the record, not an accusation.
struct AuditNote: View {
    let finding: CAGFinding

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "doc.text")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text("Audit observation")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Text(finding.note)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(finding.reference)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: Theme.Metrics.corner, style: .continuous)
                .fill(Theme.quietSurface)
        }
    }
}

#Preview {
    AuditNote(finding: CAGFinding(
        reference: "CAG Report No. 9 of 2025 (Performance Audit), Para 4.7",
        note: "Utilisation certificates for 14 district units were still pending at the close of 2024–25."
    ))
    .padding()
}
