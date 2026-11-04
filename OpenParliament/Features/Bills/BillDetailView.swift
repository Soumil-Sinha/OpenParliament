//
//  BillDetailView.swift
//  OpenParliament
//

import SwiftUI

struct BillDetailView: View {
    let bill: Bill
    @Environment(ParliamentStore.self) private var store

    private var interventions: [Speech] { store.interventions(onBill: bill.id) }
    private var speakers: [MP] { store.speakers(onBill: bill.id) }
    private var linkedSchemes: [BudgetScheme] { store.linkedSchemes(for: bill) }

    var body: some View {
        List {
            headerSection
            stageSection
            summarySection
            progressSection
            speakersSection
            linkedBudgetSection
        }
        .listStyle(.plain)
        .navigationTitle("Bill")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(bill.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)

                Text(bill.referenceLine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(bill.ministry)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
            .listRowSeparator(.hidden)
        }
    }

    private var stageSection: some View {
        Section {
            BillStageCard(stage: bill.stage, isFollowing: isFollowing)
                .listRowSeparator(.hidden)
        } header: {
            SectionHeader("Stage")
        }
    }

    private var summarySection: some View {
        Section {
            Text(bill.summary)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 2)
                .listRowSeparator(.hidden)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(bill.keyPoints, id: \.self) { point in
                    BulletPoint(text: point)
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 6)
            .listRowSeparator(.hidden)
        } header: {
            SectionHeader("What it does")
        }
    }

    private var progressSection: some View {
        Section {
            ForEach(bill.stageHistory) { event in
                StageEventRow(event: event)
            }
        } header: {
            SectionHeader("Progress")
        }
    }

    private var speakersSection: some View {
        Section {
            if speakers.isEmpty {
                Text("No interventions on record.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ForEach(speakers) { mp in
                    NavigationLink(value: mp) {
                        MemberLine(mp: mp, trailingNote: interventionNote(for: mp))
                    }
                }
            }
        } header: {
            SectionHeader("MPs who spoke on this bill")
        } footer: {
            if !interventions.isEmpty {
                Text("\(interventions.count) interventions across \(speakers.count) members.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
        }
    }

    private var linkedBudgetSection: some View {
        Section {
            if linkedSchemes.isEmpty {
                Text("No scheme is funded through this bill.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ForEach(linkedSchemes) { scheme in
                    NavigationLink(value: scheme) {
                        LinkedSchemeRow(scheme: scheme)
                    }
                }
            }
        } header: {
            SectionHeader("Linked budget")
        } footer: {
            Text("Schemes that carry the spending this bill provides for.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
        }
    }

    /// Reads and writes through the store, which persists the follow to the
    /// server's database.
    private var isFollowing: Binding<Bool> {
        Binding(
            get: { store.isFollowing(bill) },
            set: { newValue in Task { await store.setFollowing(newValue, bill: bill) } }
        )
    }

    private func interventionNote(for mp: MP) -> String {
        let count = interventions.filter { $0.mpID == mp.id }.count
        return count == 1 ? "1 speech" : "\(count) speeches"
    }
}

#Preview("Passed") {
    NavigationStack {
        BillDetailView(bill: SampleData.bills[1])
            .parliamentDestinations()
    }
    .environment(ParliamentStore.preview)
}

#Preview("Introduced") {
    NavigationStack {
        BillDetailView(bill: SampleData.bills[3])
            .parliamentDestinations()
    }
    .environment(ParliamentStore.preview)
}
