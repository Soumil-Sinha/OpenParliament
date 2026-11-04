//
//  ServerSettingsView.swift
//  OpenParliament
//

import SwiftUI

/// Where the app's data comes from. Lets the user point the app at a server
/// on another machine (needed on a physical device), check that it answers,
/// and reconnect.
struct ServerSettingsView: View {
    @Environment(ParliamentStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var address = ""
    @State private var check: CheckState = .idle

    private enum CheckState: Equatable {
        case idle
        case checking
        case reachable
        case unreachable(String)
    }

    private var parsedURL: URL? { APIConfiguration.parse(address) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("http://localhost:8080", text: $address)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: address) { check = .idle }
                } header: {
                    Text("Server address")
                } footer: {
                    Text("The simulator reaches a server on this Mac at localhost. On an iPhone, use the Mac’s address on the same Wi-Fi network.")
                }

                Section {
                    Button {
                        Task { await runCheck() }
                    } label: {
                        HStack {
                            Text("Test connection")
                            Spacer()
                            checkIndicator
                        }
                    }
                    .disabled(parsedURL == nil || check == .checking)

                    Button("Restore default") {
                        address = APIConfiguration.defaultBaseURL.absoluteString
                    }
                }

                Section {
                    KeyValueRow(label: "Source", value: store.source == .server ? "Server" : "Bundled sample")
                    KeyValueRow(label: "Members", value: "\(store.mps.count)")
                    KeyValueRow(label: "Bills", value: "\(store.bills.count)")
                    KeyValueRow(label: "Schemes", value: "\(store.schemes.count)")
                    KeyValueRow(label: "Speeches", value: "\(store.speeches.count)")
                    if let synced = store.lastSynced {
                        KeyValueRow(label: "Last synced", value: synced.formatted(date: .abbreviated, time: .shortened))
                    }
                } header: {
                    Text("Current data")
                }
            }
            .navigationTitle("Server")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Connect") {
                        guard let url = parsedURL else { return }
                        Task { await store.connect(to: url) }
                        dismiss()
                    }
                    .disabled(parsedURL == nil)
                }
            }
            .onAppear { address = store.serverURL.absoluteString }
        }
    }

    @ViewBuilder
    private var checkIndicator: some View {
        switch check {
        case .idle:
            EmptyView()
        case .checking:
            ProgressView()
        case .reachable:
            Label("Connected", systemImage: "checkmark.circle")
                .labelStyle(.titleAndIcon)
                .font(.footnote)
                .foregroundStyle(Theme.accent)
        case .unreachable(let message):
            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    private func runCheck() async {
        guard let url = parsedURL else { return }
        check = .checking
        do {
            let health = try await store.checkConnection(to: url)
            check = health.database == "connected" ? .reachable : .unreachable("Database offline")
        } catch {
            check = .unreachable("No response")
        }
    }
}

#Preview {
    ServerSettingsView()
        .environment(ParliamentStore.preview)
}
