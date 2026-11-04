//
//  Bill.swift
//  OpenParliament
//

import Foundation

enum BillStage: Int, CaseIterable, Hashable, Identifiable {
    case introduced = 0
    case committee
    case passed
    case enacted

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .introduced: "Introduced"
        case .committee: "Committee"
        case .passed: "Passed"
        case .enacted: "Enacted"
        }
    }

    /// Sentence shown under the stepper describing where the bill stands.
    var statusLine: String {
        switch self {
        case .introduced: "Awaiting first reading."
        case .committee: "Under examination by a departmentally related standing committee."
        case .passed: "Passed by both Houses, awaiting assent."
        case .enacted: "Received assent and notified."
        }
    }
}

/// A dated step in a bill's passage.
struct StageEvent: Identifiable, Hashable {
    let stage: BillStage
    let date: Date
    let detail: String

    var id: Int { stage.rawValue }
}

struct Bill: Identifiable, Hashable {
    let id: String
    let title: String
    let billNumber: String        // "Bill No. 118 of 2025"
    let house: House
    let ministry: String
    let stage: BillStage
    /// Plain-language description, deliberately free of legislative jargon.
    let summary: String
    let keyPoints: [String]
    let stageHistory: [StageEvent]
    let linkedSchemeIDs: [String]

    var introducedOn: Date {
        stageHistory.first?.date ?? Date(timeIntervalSince1970: 0)
    }

    var latestEvent: StageEvent? { stageHistory.last }

    /// "Bill No. 118 of 2025 · Lok Sabha"
    var referenceLine: String { "\(billNumber) · \(house.rawValue)" }
}
