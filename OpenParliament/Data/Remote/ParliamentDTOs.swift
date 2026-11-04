//
//  ParliamentDTOs.swift
//  OpenParliament
//
//  Wire formats returned by the server, and their mapping onto the app's
//  models. Keeping these separate means the models stay free of Codable
//  details and the server can name enumerations by stable database codes
//  ("lok_sabha", "co_sponsor") rather than by display text.
//

import Foundation

// MARK: - Payloads

struct SnapshotDTO: Decodable {
    let mps: [MPDTO]
    let bills: [BillDTO]
    let schemes: [SchemeDTO]
    let speeches: [SpeechDTO]
}

struct FollowDTO: Decodable {
    let billID: String
}

struct HealthDTO: Decodable {
    let status: String
    let database: String
}

struct MPDTO: Decodable {
    struct Attendance: Decodable {
        let session: String
        let shortLabel: String
        let attendance: Double
    }

    struct Engagement: Decodable {
        let billID: String
        let role: String
    }

    let id: String
    let name: String
    let constituency: String
    let state: String
    let party: String
    let partyAbbreviation: String
    let house: String
    let firstElected: Int
    let questionsAsked: Int
    let committees: [String]
    let attendanceHistory: [Attendance]
    let engagements: [Engagement]
}

struct BillDTO: Decodable {
    struct Event: Decodable {
        let stage: String
        let date: String
        let detail: String
    }

    let id: String
    let title: String
    let billNumber: String
    let house: String
    let ministry: String
    let stage: String
    let summary: String
    let keyPoints: [String]
    let stageHistory: [Event]
    let linkedSchemeIDs: [String]
}

struct SchemeDTO: Decodable {
    struct Year: Decodable {
        let label: String
        let fullLabel: String
        let allocation: Double
        let actual: Double
    }

    struct Finding: Decodable {
        let reference: String
        let note: String
    }

    let id: String
    let name: String
    let sector: String
    let ministry: String
    let summary: String
    let years: [Year]
    let cagFinding: Finding?
}

struct SpeechDTO: Decodable {
    let id: String
    let mpID: String
    let billID: String?
    let topic: String
    let date: String
    let durationMinutes: Int
    let excerpt: String
}

// MARK: - Mapping

/// Raised when the server sends a code the app does not recognise.
struct UnknownCodeError: LocalizedError {
    let field: String
    let value: String

    var errorDescription: String? { "Unrecognised \(field) “\(value)” from server." }
}

extension MPDTO {
    func toModel() throws -> MP {
        MP(
            id: id,
            name: name,
            constituency: constituency,
            state: state,
            party: try Party(serverName: party, abbreviation: partyAbbreviation),
            house: try House(code: house),
            firstElected: firstElected,
            committees: committees,
            questionsAsked: questionsAsked,
            attendanceHistory: attendanceHistory.map {
                SessionAttendance(session: $0.session, shortLabel: $0.shortLabel, attendance: $0.attendance)
            },
            engagements: try engagements.map {
                BillEngagement(billID: $0.billID, role: try EngagementRole(code: $0.role))
            }
        )
    }
}

extension BillDTO {
    func toModel() throws -> Bill {
        Bill(
            id: id,
            title: title,
            billNumber: billNumber,
            house: try House(code: house),
            ministry: ministry,
            stage: try BillStage(code: stage),
            summary: summary,
            keyPoints: keyPoints,
            stageHistory: try stageHistory.map {
                StageEvent(stage: try BillStage(code: $0.stage), date: try ServerDate.parse($0.date), detail: $0.detail)
            },
            linkedSchemeIDs: linkedSchemeIDs
        )
    }
}

extension SchemeDTO {
    func toModel() -> BudgetScheme {
        BudgetScheme(
            id: id,
            name: name,
            sector: sector,
            ministry: ministry,
            summary: summary,
            years: years.map {
                FiscalYearSpend(label: $0.label, fullLabel: $0.fullLabel, allocation: $0.allocation, actual: $0.actual)
            },
            cagFinding: cagFinding.map { CAGFinding(reference: $0.reference, note: $0.note) }
        )
    }
}

extension SpeechDTO {
    func toModel() throws -> Speech {
        Speech(
            id: id,
            mpID: mpID,
            billID: billID,
            topic: topic,
            date: try ServerDate.parse(date),
            durationMinutes: durationMinutes,
            excerpt: excerpt
        )
    }
}

// MARK: - Codes

private extension House {
    init(code: String) throws {
        switch code {
        case "lok_sabha": self = .lokSabha
        case "rajya_sabha": self = .rajyaSabha
        default: throw UnknownCodeError(field: "house", value: code)
        }
    }
}

private extension BillStage {
    init(code: String) throws {
        switch code {
        case "introduced": self = .introduced
        case "committee": self = .committee
        case "passed": self = .passed
        case "enacted": self = .enacted
        default: throw UnknownCodeError(field: "stage", value: code)
        }
    }
}

private extension EngagementRole {
    init(code: String) throws {
        switch code {
        case "sponsor": self = .sponsor
        case "co_sponsor": self = .coSponsor
        case "committee_member": self = .committeeMember
        case "debated": self = .debated
        default: throw UnknownCodeError(field: "role", value: code)
        }
    }
}

private extension Party {
    init(serverName: String, abbreviation: String) throws {
        if let party = Party(rawValue: serverName)
            ?? Party.allCases.first(where: { $0.abbreviation == abbreviation }) {
            self = party
        } else {
            throw UnknownCodeError(field: "party", value: serverName)
        }
    }
}

/// Calendar dates arrive as "2025-03-11". They are pinned to midday, matching
/// the fixtures, so no time zone can push them onto a neighbouring day.
private enum ServerDate {
    static func parse(_ text: String) throws -> Date {
        let parts = text.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { throw UnknownCodeError(field: "date", value: text) }
        var components = DateComponents()
        components.year = parts[0]
        components.month = parts[1]
        components.day = parts[2]
        components.hour = 12
        guard let date = Calendar(identifier: .gregorian).date(from: components) else {
            throw UnknownCodeError(field: "date", value: text)
        }
        return date
    }
}
