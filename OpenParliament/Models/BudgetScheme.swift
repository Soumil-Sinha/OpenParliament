//
//  BudgetScheme.swift
//  OpenParliament
//

import Foundation

struct FiscalYearSpend: Identifiable, Hashable {
    let label: String       // "FY25"
    let fullLabel: String   // "2024–25"
    let allocation: Double  // ₹ crore
    let actual: Double      // ₹ crore

    var id: String { label }

    var utilisation: Double {
        allocation > 0 ? (actual / allocation) * 100 : 0
    }
}

enum SpendSeries: String, CaseIterable, Hashable {
    case allocation = "Allocation"
    case actual = "Actual"
}

/// Flattened point consumed by the grouped bar chart.
struct SpendPoint: Identifiable, Hashable {
    let yearLabel: String
    let series: SpendSeries
    let amount: Double

    var id: String { "\(yearLabel)-\(series.rawValue)" }
}

/// A finding lifted from a Comptroller and Auditor General report. Presented
/// as a neutral note, not as an alarm.
struct CAGFinding: Hashable {
    let reference: String   // "CAG Report No. 9 of 2025, Para 4.7"
    let note: String
}

struct BudgetScheme: Identifiable, Hashable {
    let id: String
    let name: String
    let sector: String
    let ministry: String
    let summary: String
    let years: [FiscalYearSpend]
    let cagFinding: CAGFinding?

    var totalAllocation: Double { years.reduce(0) { $0 + $1.allocation } }
    var totalActual: Double { years.reduce(0) { $0 + $1.actual } }
    var unspent: Double { totalAllocation - totalActual }

    var utilisation: Double {
        totalAllocation > 0 ? (totalActual / totalAllocation) * 100 : 0
    }

    var spendPoints: [SpendPoint] {
        years.flatMap { year in
            [
                SpendPoint(yearLabel: year.label, series: .allocation, amount: year.allocation),
                SpendPoint(yearLabel: year.label, series: .actual, amount: year.actual)
            ]
        }
    }
}
