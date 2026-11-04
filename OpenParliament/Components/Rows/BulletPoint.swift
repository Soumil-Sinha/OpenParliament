//
//  BulletPoint.swift
//  OpenParliament
//

import SwiftUI

/// One plain-language point in a bill summary.
struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.body)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        BulletPoint(text: "Government exemptions must be notified individually, with stated grounds.")
        BulletPoint(text: "Consent managers are licensed and must offer a single withdrawal screen.")
    }
    .padding()
}
