//
//  GenerateSeed.swift
//  OpenParliament Server
//
//  Compiled together with the app's Models/ and Data/ folders by
//  generate-seed.sh. Prints db/seed.sql so the database is seeded with exactly
//  the records the app bundles for offline use and previews.
//

import Foundation

func q(_ s: String) -> String { "'" + s.replacingOccurrences(of: "'", with: "''") + "'" }
func d(_ date: Date) -> String {
    let f = DateFormatter(); f.calendar = Calendar(identifier: .gregorian); f.dateFormat = "yyyy-MM-dd"; f.timeZone = .current
    return q(f.string(from: date))
}
func num(_ x: Double) -> String { String(format: "%.2f", x) }
func stage(_ s: BillStage) -> String { q(["introduced","committee","passed","enacted"][s.rawValue]) }
func role(_ r: EngagementRole) -> String {
    switch r { case .sponsor: q("sponsor"); case .coSponsor: q("co_sponsor"); case .committeeMember: q("committee_member"); case .debated: q("debated") }
}
func house(_ h: House) -> String { q(h == .lokSabha ? "lok_sabha" : "rajya_sabha") }

var out: [String] = []
func emit(_ s: String) { out.append(s) }
func insert(_ table: String, _ cols: String, _ rows: [String]) {
    guard !rows.isEmpty else { return }
    emit("INSERT INTO \(table) (\(cols)) VALUES\n    " + rows.joined(separator: ",\n    ") + ";\n")
}

emit("-- Generated from the app's bundled fixtures (OpenParliament/Data). Do not edit by hand;\n-- run Server/tools/generate-seed.sh instead so the app's offline data and the database stay identical.\n\nBEGIN;\n")
insert("parties", "abbreviation, name", Party.allCases.map { "(\(q($0.abbreviation)), \(q($0.rawValue)))" })
insert("parliament_sessions", "ordinal, name, short_label", Fixture.sessionLabels.enumerated().map { "(\($0.offset + 1), \(q($0.element.name)), \(q($0.element.short)))" })

var ministries = [String]()
for m in SampleData.bills.map(\.ministry) + SampleData.schemes.map(\.ministry) where !ministries.contains(m) { ministries.append(m) }
insert("ministries", "name", ministries.map { "(\(q($0)))" })
var committees = [String]()
for c in SampleData.mps.flatMap(\.committees) where !committees.contains(c) { committees.append(c) }
insert("committees", "name", committees.map { "(\(q($0)))" })

func ministryRef(_ m: String) -> String { "(SELECT id FROM ministries WHERE name = \(q(m)))" }

insert("mps", "id, name, constituency, state, party_abbreviation, house, first_elected, questions_asked",
       SampleData.mps.map { "(\(q($0.id)), \(q($0.name)), \(q($0.constituency)), \(q($0.state)), \(q($0.party.abbreviation)), \(house($0.house)), \($0.firstElected), \($0.questionsAsked))" })
insert("mp_committees", "mp_id, committee_id, position",
       SampleData.mps.flatMap { mp in mp.committees.enumerated().map { "(\(q(mp.id)), (SELECT id FROM committees WHERE name = \(q($0.element))), \($0.offset))" } })
insert("attendance_records", "mp_id, session_id, attendance_percent",
       SampleData.mps.flatMap { mp in mp.attendanceHistory.map { "(\(q(mp.id)), (SELECT id FROM parliament_sessions WHERE name = \(q($0.session))), \(num($0.attendance)))" } })

insert("bills", "id, title, bill_number, house, ministry_id, stage, summary",
       SampleData.bills.map { "(\(q($0.id)), \(q($0.title)), \(q($0.billNumber)), \(house($0.house)), \(ministryRef($0.ministry)), \(stage($0.stage)), \(q($0.summary)))" })
insert("bill_key_points", "bill_id, position, point",
       SampleData.bills.flatMap { b in b.keyPoints.enumerated().map { "(\(q(b.id)), \($0.offset), \(q($0.element)))" } })
insert("bill_stage_events", "bill_id, stage, event_date, detail",
       SampleData.bills.flatMap { b in b.stageHistory.map { "(\(q(b.id)), \(stage($0.stage)), \(d($0.date)), \(q($0.detail)))" } })

insert("schemes", "id, name, sector, ministry_id, summary",
       SampleData.schemes.map { "(\(q($0.id)), \(q($0.name)), \(q($0.sector)), \(ministryRef($0.ministry)), \(q($0.summary)))" })
insert("fiscal_year_spend", "scheme_id, label, full_label, allocation_crore, actual_crore",
       SampleData.schemes.flatMap { s in s.years.map { "(\(q(s.id)), \(q($0.label)), \(q($0.fullLabel)), \(num($0.allocation)), \(num($0.actual)))" } })
insert("cag_findings", "scheme_id, reference, note",
       SampleData.schemes.compactMap { s in s.cagFinding.map { "(\(q(s.id)), \(q($0.reference)), \(q($0.note)))" } })

insert("bill_schemes", "bill_id, scheme_id",
       SampleData.bills.flatMap { b in b.linkedSchemeIDs.map { "(\(q(b.id)), \(q($0)))" } })
insert("bill_engagements", "mp_id, bill_id, role",
       SampleData.mps.flatMap { mp in mp.engagements.map { "(\(q(mp.id)), \(q($0.billID)), \(role($0.role)))" } })
insert("speeches", "id, mp_id, bill_id, topic, spoken_on, duration_minutes, excerpt",
       SampleData.speeches.map { "(\(q($0.id)), \(q($0.mpID)), \($0.billID.map(q) ?? "NULL"), \(q($0.topic)), \(d($0.date)), \($0.durationMinutes), \(q($0.excerpt)))" })
emit("COMMIT;")
print(out.joined(separator: "\n"))
