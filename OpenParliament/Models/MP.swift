//
//  MP.swift
//  OpenParliament
//

import Foundation

/// Sitting attendance recorded for one parliamentary session.
struct SessionAttendance: Identifiable, Hashable {
    let session: String      // "Budget 2023"
    let shortLabel: String   // "23B"
    let attendance: Double   // 0...100

    var id: String { session }
}

enum EngagementRole: String, Hashable, CaseIterable {
    case sponsor = "Sponsor"
    case coSponsor = "Co-sponsor"
    case committeeMember = "Committee member"
    case debated = "Spoke in debate"

    /// Roles that put a member on the record as an author of the bill.
    var isAuthorship: Bool {
        self == .sponsor || self == .coSponsor
    }
}

struct BillEngagement: Identifiable, Hashable {
    let billID: String
    let role: EngagementRole

    var id: String { "\(billID)-\(role.rawValue)" }
}

struct MP: Identifiable, Hashable {
    let id: String
    let name: String
    let constituency: String
    let state: String
    let party: Party
    let house: House
    let firstElected: Int
    let committees: [String]
    let questionsAsked: Int
    let attendanceHistory: [SessionAttendance]
    let engagements: [BillEngagement]

    /// Mean sitting attendance across every recorded session.
    var attendance: Double {
        guard !attendanceHistory.isEmpty else { return 0 }
        let total = attendanceHistory.reduce(0) { $0 + $1.attendance }
        return total / Double(attendanceHistory.count)
    }

    var latestSession: SessionAttendance? { attendanceHistory.last }

    /// Change in attendance between the first and the most recent session.
    var attendanceTrend: Double {
        guard let first = attendanceHistory.first, let last = attendanceHistory.last else { return 0 }
        return last.attendance - first.attendance
    }

    var constituencyLine: String { "\(constituency), \(state)" }
}
