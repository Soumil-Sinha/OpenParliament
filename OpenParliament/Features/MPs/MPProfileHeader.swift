//
//  MPProfileHeader.swift
//  OpenParliament
//

import SwiftUI

/// Identity block at the top of a member profile.
struct MPProfileHeader: View {
    let mp: MP

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AvatarView(size: 64)

            VStack(alignment: .leading, spacing: 5) {
                Text(mp.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                Text(mp.constituencyLine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    MetaTag(text: mp.party.abbreviation)
                    Text(mp.house.rawValue)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 4)
    }
}

#Preview {
    MPProfileHeader(mp: SampleData.mps[2])
        .padding()
}
