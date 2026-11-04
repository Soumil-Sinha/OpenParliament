//
//  MemberLine.swift
//  OpenParliament
//

import SwiftUI

/// Compact member row, used wherever a member is referenced from another
/// record — the speaker list on a bill, for instance.
struct MemberLine: View {
    let mp: MP
    var trailingNote: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(size: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(mp.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                Text("\(mp.party.abbreviation) · \(mp.constituency)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if let trailingNote {
                Text(trailingNote)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    MemberLine(mp: SampleData.mps[0], trailingNote: "2 speeches")
        .padding()
}
