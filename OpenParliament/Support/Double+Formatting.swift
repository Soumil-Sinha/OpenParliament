//
//  Double+Formatting.swift
//  OpenParliament
//

import Foundation

extension Double {

    /// "42,500" — bare grouped number, for table columns.
    var groupedWhole: String {
        formatted(.number.precision(.fractionLength(0)))
    }

    /// "₹42,500 Cr"
    var croreFormatted: String {
        "₹\(groupedWhole) Cr"
    }

    /// Compact axis form: "5k", "12.5k".
    var croreAxisLabel: String {
        if self >= 1_000 {
            let thousands = self / 1_000
            return "\(thousands.formatted(.number.precision(.fractionLength(0...1))))k"
        }
        return groupedWhole
    }

    /// "92%"
    var percentWhole: String {
        "\(Int(rounded()))%"
    }

    /// "+3.1 pts" / "−4.0 pts" / "no change"
    var signedPoints: String {
        let magnitude = abs(self).formatted(.number.precision(.fractionLength(1)))
        if self > 0.05 { return "+\(magnitude) pts" }
        if self < -0.05 { return "−\(magnitude) pts" }
        return "no change"
    }
}
