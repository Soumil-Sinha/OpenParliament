//
//  RootTabView.swift
//  OpenParliament
//

import SwiftUI

struct RootTabView: View {
    @Environment(ParliamentStore.self) private var store

    var body: some View {
        Group {
            if store.hasContent {
                tabs
            } else if case .failed(let message) = store.phase {
                unreachable(message)
            } else {
                ProgressView("Loading Parliament…")
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            if store.phase == .idle { await store.load() }
        }
    }

    /// The banner sits above the tab view rather than in a safe-area inset, so
    /// it pushes each tab's navigation bar down instead of covering it.
    private var tabs: some View {
        VStack(spacing: 0) {
            banner
            tabView
        }
    }

    private var tabView: some View {
        TabView {
            MPListView()
                .tabItem {
                    Label("MPs", systemImage: "person.2")
                }

            BillListView()
                .tabItem {
                    Label("Bills", systemImage: "doc.plaintext")
                }

            BudgetListView()
                .tabItem {
                    Label("Budget", systemImage: "chart.bar")
                }

            FollowingListView()
                .tabItem {
                    Label("Following", systemImage: "bell")
                }
                .badge(store.followedBillIDs.count)
        }
        .tint(Theme.accent)
    }

    @ViewBuilder
    private var banner: some View {
        if let notice = store.notice {
            StatusBanner(
                systemImage: "exclamationmark.circle",
                message: notice,
                actionTitle: "Dismiss",
                action: store.dismissNotice
            )
        } else if store.source == .bundled {
            StatusBanner(
                systemImage: "externaldrive",
                message: "Offline · showing data bundled with the app.",
                actionTitle: "Retry",
                action: { Task { await store.load() } }
            )
        }
    }

    private func unreachable(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Server unavailable", systemImage: "wifi.slash")
        } description: {
            Text("\(message)\nStart it with `npm start` in the Server folder, or continue with the data bundled in the app.")
        } actions: {
            // A fixed-width column so both buttons share one width instead of
            // hugging their labels.
            VStack(spacing: 10) {
                Button("Try again") {
                    Task { await store.load() }
                }
                .buttonStyle(AccentButtonStyle())

                Button("Use offline data", action: store.useBundledData)
                    .buttonStyle(AccentButtonStyle(prominent: false))
            }
            .frame(width: 240)
        }
    }
}

#Preview {
    RootTabView()
        .environment(ParliamentStore.preview)
}

#Preview("Dark") {
    RootTabView()
        .environment(ParliamentStore.preview)
        .preferredColorScheme(.dark)
}
