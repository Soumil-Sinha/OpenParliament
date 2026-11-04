//
//  MPProfileView.swift
//  OpenParliament
//

import SwiftUI

struct MPProfileView: View {
    let mp: MP
    @Environment(ParliamentStore.self) private var store

    private var interventions: [Speech] { store.interventions(byMP: mp.id) }

    private var engagedBills: [(engagement: BillEngagement, bill: Bill)] {
        mp.engagements.compactMap { engagement in
            guard let bill = store.bill(id: engagement.billID) else { return nil }
            return (engagement, bill)
        }
    }

    var body: some View {
        List {
            Section {
                MPProfileHeader(mp: mp)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 4)
            }

            attendanceSection
            billsSection
            speechesSection
            committeesSection
        }
        .listStyle(.plain)
        .navigationTitle(mp.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var attendanceSection: some View {
        Section {
            StatRow {
                StatTile(
                    value: mp.attendance.percentWhole,
                    label: "Attendance",
                    emphasized: true,
                    caption: "\(mp.attendanceHistory.count) sessions"
                )
                StatTile(
                    value: mp.attendanceTrend.signedPoints,
                    label: "Since Budget 2022",
                    caption: mp.latestSession.map { "Latest \($0.session)" }
                )
                StatTile(
                    value: "\(mp.questionsAsked)",
                    label: "Questions asked",
                    caption: "Since \(mp.firstElected)"
                )
            }
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)

            AttendanceChart(history: mp.attendanceHistory, average: mp.attendance)
                .listRowSeparator(.hidden)
        } header: {
            SectionHeader("Attendance by session")
        } footer: {
            Text("B Budget · M Monsoon · W Winter. Dashed line marks this member's average.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        }
    }

    private var billsSection: some View {
        Section {
            ForEach(engagedBills, id: \.engagement.id) { item in
                NavigationLink(value: item.bill) {
                    BillEngagementRow(bill: item.bill, role: item.engagement.role)
                }
            }
        } header: {
            SectionHeader("Bills engaged with")
        }
    }

    private var speechesSection: some View {
        Section {
            ForEach(interventions) { speech in
                if let billID = speech.billID, let bill = store.bill(id: billID) {
                    NavigationLink(value: bill) {
                        SpeechRow(speech: speech, isOnBill: true)
                    }
                } else {
                    SpeechRow(speech: speech)
                }
            }
        } header: {
            SectionHeader("Spoke on")
        } footer: {
            Text("\(interventions.count) interventions on record.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
        }
    }

    private var committeesSection: some View {
        Section {
            ForEach(mp.committees, id: \.self) { committee in
                Text(committee)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 2)
            }
        } header: {
            SectionHeader("Committees")
        }
    }
}

#Preview {
    NavigationStack {
        MPProfileView(mp: SampleData.mps[0])
            .parliamentDestinations()
    }
    .environment(ParliamentStore.preview)
}
