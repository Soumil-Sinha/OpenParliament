//
//  BudgetListView.swift
//  OpenParliament
//

import SwiftUI

struct BudgetListView: View {
    @Environment(ParliamentStore.self) private var store

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.schemes) { scheme in
                        NavigationLink(value: scheme) {
                            SchemeRow(scheme: scheme)
                        }
                    }
                } header: {
                    SectionHeader("Schemes")
                } footer: {
                    totals
                }
            }
            .listStyle(.plain)
            .refreshable { await store.load() }
            .navigationTitle("Budget")
            .parliamentDestinations()
        }
    }

    private var totals: some View {
        VStack(alignment: .leading, spacing: 6) {
            KeyValueRow(
                label: "Allocated, all schemes",
                value: store.totalAllocation.croreFormatted
            )
            KeyValueRow(
                label: "Spent, all schemes",
                value: store.totalActual.croreFormatted
            )
            Text("Four-year totals, 2021–22 to 2024–25.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .padding(.top, 2)
        }
        .padding(.top, 14)
        .padding(.bottom, 12)
    }
}

#Preview {
    BudgetListView()
        .environment(ParliamentStore.preview)
}
