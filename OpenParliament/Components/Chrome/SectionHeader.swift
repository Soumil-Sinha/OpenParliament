//
//  SectionHeader.swift
//  OpenParliament
//

import SwiftUI

/// Quiet uppercase rule used above every list section.
struct SectionHeader: View {
    let title: String

    init(_ title: String) { self.title = title }

    var body: some View {
        Text(title.uppercased())
            .font(.caption)
            .fontWeight(.medium)
            .tracking(0.7)
            .foregroundStyle(.secondary)
            .textCase(nil)
            .padding(.vertical, 2)
    }
}

#Preview {
    SectionHeader("Bills engaged with")
        .padding()
}
