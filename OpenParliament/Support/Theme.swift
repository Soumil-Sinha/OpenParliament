//
//  Theme.swift
//  OpenParliament
//
//  Design tokens. The palette is deliberately almost entirely grayscale — a
//  single soft periwinkle accent is the only colour in the app, and it is
//  reserved for active states, the selected tab, key marks in charts and
//  primary actions.
//

import SwiftUI
import UIKit

enum Theme {

    /// Soft periwinkle. The pastel value (#A8C9E8) is used as-is on the
    /// near-black dark background; light mode uses a slightly deeper mix of the
    /// same hue so it stays legible against white.
    static let accent = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.659, green: 0.788, blue: 0.910, alpha: 1)   // #A8C9E8
            : UIColor(red: 0.310, green: 0.525, blue: 0.745, alpha: 1)   // #4F86BE
    })

    /// Foreground for content sitting on top of an `accent` fill.
    static let onAccent = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.055, green: 0.066, blue: 0.078, alpha: 1)
            : .white
    })

    /// The "everything that isn't the answer" series colour in charts.
    static let chartNeutral = Color(uiColor: .systemGray3)

    /// Thin rules and hairline borders.
    static let hairline = Color(uiColor: .separator)

    /// Quiet surface used for the audit note block.
    static let quietSurface = Color(uiColor: .secondarySystemBackground)

    enum Metrics {
        static let gutter: CGFloat = 16
        static let blockSpacing: CGFloat = 12
        static let corner: CGFloat = 10
    }
}
