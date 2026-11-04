//
//  StatusBanner.swift
//  OpenParliament
//

import SwiftUI

/// Slim strip pinned under the navigation bar for connection state — offline
/// mode, or a refresh that didn't go through. Grayscale like the audit note:
/// it informs, it doesn't alarm.
struct StatusBanner: View {
    let systemImage: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.accent)
            }
        }
        .padding(.horizontal, Theme.Metrics.gutter)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.quietSurface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.hairline).frame(height: 0.5)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        StatusBanner(
            systemImage: "externaldrive",
            message: "Offline · showing data bundled with the app.",
            actionTitle: "Retry",
            action: {}
        )
        StatusBanner(systemImage: "exclamationmark.circle", message: "Couldn’t refresh. Showing the last copy.")
        Spacer()
    }
}
