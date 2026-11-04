//
//  BillListView.swift
//  OpenParliament
//

import SwiftUI

struct BillListView: View {
    @Environment(ParliamentStore.self) private var store
    @State private var query = ""

    private var results: [Bill] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let matched = trimmed.isEmpty ? store.bills : store.bills.filter { $0.matches(trimmed) }
        // Most recent legislative activity first.
        return matched.sorted { lhs, rhs in
            (lhs.latestEvent?.date ?? lhs.introducedOn) > (rhs.latestEvent?.date ?? rhs.introducedOn)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if results.isEmpty {
                    ContentUnavailableView.search(text: query)
                } else {
                    list
                }
            }
            .navigationTitle("Bills")
            .searchable(text: $query, prompt: "Title, ministry, or stage")
            .parliamentDestinations()
        }
    }

    private var list: some View {
        List {
            Section {
                ForEach(results) { bill in
                    NavigationLink(value: bill) {
                        BillRow(bill: bill)
                    }
                }
            } header: {
                SectionHeader("Bills before Parliament")
            } footer: {
                Text("Sorted by most recent legislative activity.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
                    .padding(.bottom, 12)
            }
        }
        .listStyle(.plain)
        .refreshable { await store.load() }
    }
}

private extension Bill {
    /// Free-text match across the fields shown in the row.
    func matches(_ term: String) -> Bool {
        title.localizedCaseInsensitiveContains(term)
            || ministry.localizedCaseInsensitiveContains(term)
            || billNumber.localizedCaseInsensitiveContains(term)
            || stage.title.localizedCaseInsensitiveContains(term)
    }
}

#Preview {
    BillListView()
        .environment(ParliamentStore.preview)
}
