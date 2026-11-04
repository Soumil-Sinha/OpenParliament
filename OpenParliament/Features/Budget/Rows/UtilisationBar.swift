//
//  UtilisationBar.swift
//  OpenParliament
//

import SwiftUI

/// Thin utilisation track. The filled portion is the one data point worth
/// colouring in a scheme row.
struct UtilisationBar: View {
    let fraction: Double

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.chartNeutral.opacity(0.5))
                Capsule()
                    .fill(Theme.accent)
                    .frame(width: proxy.size.width * min(max(fraction, 0), 1))
            }
        }
        .frame(width: 64, height: 4)
        .accessibilityHidden(true)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        UtilisationBar(fraction: 0.96)
        UtilisationBar(fraction: 0.77)
        UtilisationBar(fraction: 0.35)
    }
    .padding()
}
