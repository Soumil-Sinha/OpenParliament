//
//  FollowingListView.swift
//  OpenParliament
//

import SwiftUI

/// Bills this device follows. Each follow is a row in the server's
/// `bill_follows` table, so the list survives reinstalls of the server and
/// is shared by every screen that shows a follow button.
struct FollowingListView: View {
    @Environment(ParliamentStore.self) private var store
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            Group {
                if store.followedBills.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Following")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Label("Server settings", systemImage: "server.rack")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                ServerSettingsView()
            }
            .parliamentDestinations()
        }
    }

    private var list: some View {
        List {
            Section {
                ForEach(store.followedBills) { bill in
                    NavigationLink(value: bill) {
                        BillRow(bill: bill)
                    }
                    .swipeActions {
                        Button("Unfollow", systemImage: "bell.slash") {
                            Task { await store.setFollowing(false, bill: bill) }
                        }
                        .tint(Theme.chartNeutral)
                    }
                }
            } header: {
                SectionHeader("Bills you follow")
            } footer: {
                Text(syncNote)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
                    .padding(.bottom, 12)
            }
        }
        .listStyle(.plain)
        .refreshable { await store.load() }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No bills followed", systemImage: "bell")
        } description: {
            Text("Open any bill and tap Follow this bill to keep track of it here.")
        }
    }

    private var syncNote: String {
        switch store.source {
        case .server:
            if let synced = store.lastSynced {
                "Saved to the OpenParliament server · synced \(synced.formatted(date: .omitted, time: .shortened))."
            } else {
                "Saved to the OpenParliament server."
            }
        case .bundled:
            "Offline · follows are kept on this device until the server is reachable."
        }
    }
}

#Preview {
    FollowingListView()
        .environment(ParliamentStore.preview)
}
