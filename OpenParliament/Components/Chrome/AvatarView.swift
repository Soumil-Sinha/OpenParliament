//
//  AvatarView.swift
//  OpenParliament
//

import SwiftUI

/// Photo placeholder. No images ship with the app, so every member gets the
/// same neutral glyph.
struct AvatarView: View {
    var size: CGFloat = 40

    var body: some View {
        Circle()
            .fill(Color(uiColor: .tertiarySystemFill))
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.42))
                    .foregroundStyle(.secondary)
            }
            .overlay {
                Circle().strokeBorder(Theme.hairline, lineWidth: 0.5)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(size: 32)
        AvatarView(size: 40)
        AvatarView(size: 64)
    }
    .padding()
}
