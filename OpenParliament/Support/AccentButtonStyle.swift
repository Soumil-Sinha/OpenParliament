//
//  AccentButtonStyle.swift
//  OpenParliament
//

import SwiftUI

/// Filled accent button for the single primary action on a screen. Set
/// `prominent` to false for the resolved/secondary state, which drops back to a
/// hairline outline.
struct AccentButtonStyle: ButtonStyle {
    var prominent: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(prominent ? Theme.onAccent : Color.primary)
            .background {
                RoundedRectangle(cornerRadius: Theme.Metrics.corner, style: .continuous)
                    .fill(prominent ? Theme.accent : Color.clear)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Metrics.corner, style: .continuous)
                    .strokeBorder(prominent ? Color.clear : Theme.hairline, lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.75 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 12) {
        Button { } label: { Label("Follow this bill", systemImage: "bell") }
            .buttonStyle(AccentButtonStyle())
        Button { } label: { Label("Following this bill", systemImage: "checkmark") }
            .buttonStyle(AccentButtonStyle(prominent: false))
    }
    .padding()
}
