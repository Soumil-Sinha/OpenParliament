//
//  MPListView.swift
//  OpenParliament
//

import SwiftUI

struct MPListView: View {
    @Environment(ParliamentStore.self) private var store
    @State private var query = ""
    @State private var sort: MPSortOption = .name

    private var results: [MP] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let matched = trimmed.isEmpty ? store.mps : store.mps.filter { $0.matches(trimmed) }
        return sort.apply(to: matched)
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
            .navigationTitle("MPs")
            .searchable(text: $query, prompt: "Name, constituency, or party")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $sort) {
                            ForEach(MPSortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .parliamentDestinations()
        }
    }

    private var list: some View {
        List {
            Section {
                ForEach(results) { mp in
                    NavigationLink(value: mp) {
                        MPRow(mp: mp)
                    }
                }
            } header: {
                SectionHeader("Members")
            } footer: {
                Text("\(results.count) of \(store.mps.count) members · attendance is the mean across the last seven sessions.")
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

// MARK: - Sorting & filtering

enum MPSortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case attendance = "Attendance"
    case constituency = "Constituency"

    var id: String { rawValue }

    func apply(to mps: [MP]) -> [MP] {
        switch self {
        case .name: mps.sorted { $0.name < $1.name }
        case .attendance: mps.sorted { $0.attendance > $1.attendance }
        case .constituency: mps.sorted { $0.constituency < $1.constituency }
        }
    }
}

private extension MP {
    /// Free-text match across the fields shown in the row.
    func matches(_ term: String) -> Bool {
        name.localizedCaseInsensitiveContains(term)
            || constituency.localizedCaseInsensitiveContains(term)
            || state.localizedCaseInsensitiveContains(term)
            || party.rawValue.localizedCaseInsensitiveContains(term)
            || party.abbreviation.localizedCaseInsensitiveContains(term)
    }
}

#Preview {
    MPListView()
        .environment(ParliamentStore.preview)
}
