//
//  Speech.swift
//  OpenParliament
//

import Foundation

/// One intervention on the floor. `billID` is nil for interventions that are
/// not tied to a bill — zero hour, calling attention, special mentions.
struct Speech: Identifiable, Hashable {
    let id: String
    let mpID: String
    let billID: String?
    let topic: String
    let date: Date
    let durationMinutes: Int
    let excerpt: String
}
