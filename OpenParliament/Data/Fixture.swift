//
//  Fixture.swift
//  OpenParliament
//
//  Small builders shared by the sample fixture files.
//

import Foundation

enum Fixture {

    /// Deterministic date builder — the fixtures must not depend on "now".
    static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar(identifier: .gregorian).date(from: components)
            ?? Date(timeIntervalSince1970: 0)
    }

    /// Session labels, oldest first, shared by every member's attendance history.
    static let sessionLabels: [(name: String, short: String)] = [
        ("Budget 2022", "22B"),
        ("Monsoon 2022", "22M"),
        ("Winter 2022", "22W"),
        ("Budget 2023", "23B"),
        ("Monsoon 2023", "23M"),
        ("Winter 2023", "23W"),
        ("Budget 2024", "24B")
    ]

    /// Pairs a run of percentages with `sessionLabels`, oldest first.
    static func attendance(_ values: [Double]) -> [SessionAttendance] {
        zip(sessionLabels, values).map { label, value in
            SessionAttendance(session: label.name, shortLabel: label.short, attendance: value)
        }
    }
}
