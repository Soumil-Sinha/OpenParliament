//
//  ParliamentStore.swift
//  OpenParliament
//
//  The app's single source of truth. Loads the dataset from the server's
//  PostgreSQL database, keeps the device's followed bills in sync, and holds
//  the lookups that join members, bills, schemes and speeches.
//
//  When the server can't be reached the user may continue with the bundled
//  `SampleData`; follows made in that mode stay on the device only.
//

import Foundation
import Observation

@Observable
final class ParliamentStore {

    enum Phase: Equatable {
        case idle
        case loading
        case ready
        case failed(String)
    }

    enum Source: Equatable {
        /// Records came from the server and follows sync to the database.
        case server
        /// Records are the bundled sample data; follows stay on the device.
        case bundled
    }

    // MARK: - State

    private(set) var mps: [MP] = []
    private(set) var bills: [Bill] = []
    private(set) var schemes: [BudgetScheme] = []
    private(set) var speeches: [Speech] = []
    /// Followed bill IDs, most recently followed first.
    private(set) var followedBillIDs: [String] = []

    private(set) var phase: Phase = .idle
    private(set) var source: Source = .server
    private(set) var lastSynced: Date?
    /// A non-fatal problem worth telling the user about — a failed refresh or
    /// a follow that couldn't be saved. Cleared by `dismissNotice()`.
    private(set) var notice: String?

    private var api: ParliamentAPI

    init(api: ParliamentAPI = ParliamentAPI(baseURL: APIConfiguration.baseURL)) {
        self.api = api
    }

    var hasContent: Bool { !mps.isEmpty || !bills.isEmpty || !schemes.isEmpty }
    var serverURL: URL { api.baseURL }

    // MARK: - Loading

    /// Fetches everything from the server. On first launch a failure moves to
    /// `.failed`; on a refresh the existing records are kept and a notice is
    /// raised instead.
    func load() async {
        guard phase != .loading else { return }
        let hadContent = hasContent
        phase = .loading

        do {
            async let snapshot = api.snapshot()
            async let follows = api.followedBillIDs()
            let (payload, followed) = try await (snapshot, follows)

            mps = try payload.mps.map { try $0.toModel() }
            bills = try payload.bills.map { try $0.toModel() }
            schemes = payload.schemes.map { $0.toModel() }
            speeches = try payload.speeches.map { try $0.toModel() }
            followedBillIDs = followed
            source = .server
            lastSynced = .now
            notice = nil
            phase = .ready
        } catch {
            if hadContent {
                notice = error.localizedDescription
                phase = .ready
            } else {
                phase = .failed(error.localizedDescription)
            }
        }
    }

    /// Continues without the server, on the records bundled with the app.
    func useBundledData() {
        mps = SampleData.mps
        bills = SampleData.bills
        schemes = SampleData.schemes
        speeches = SampleData.speeches
        source = .bundled
        phase = .ready
    }

    /// Points the store at a different server and reloads from it.
    func connect(to url: URL) async {
        APIConfiguration.save(url == APIConfiguration.defaultBaseURL ? nil : url)
        api = ParliamentAPI(baseURL: url)
        phase = .idle
        await load()
    }

    func checkConnection(to url: URL) async throws -> HealthDTO {
        try await ParliamentAPI(baseURL: url).health()
    }

    func dismissNotice() {
        notice = nil
    }

    // MARK: - Following

    func isFollowing(_ bill: Bill) -> Bool {
        followedBillIDs.contains(bill.id)
    }

    var followedBills: [Bill] {
        followedBillIDs.compactMap { bill(id: $0) }
    }

    /// Updates the UI immediately, then writes through to the server. If the
    /// write fails the change is rolled back and a notice explains why.
    func setFollowing(_ follow: Bool, bill: Bill) async {
        guard follow != isFollowing(bill) else { return }
        let previous = followedBillIDs
        if follow {
            followedBillIDs.insert(bill.id, at: 0)
        } else {
            followedBillIDs.removeAll { $0 == bill.id }
        }

        guard source == .server else { return }
        do {
            if follow {
                try await api.follow(billID: bill.id)
            } else {
                try await api.unfollow(billID: bill.id)
            }
        } catch {
            followedBillIDs = previous
            notice = "Couldn’t save that change. \(error.localizedDescription)"
        }
    }

    // MARK: - Lookups

    func mp(id: String) -> MP? {
        mps.first { $0.id == id }
    }

    func bill(id: String) -> Bill? {
        bills.first { $0.id == id }
    }

    func scheme(id: String) -> BudgetScheme? {
        schemes.first { $0.id == id }
    }

    /// Interventions on a bill, most recent first.
    func interventions(onBill billID: String) -> [Speech] {
        speeches.filter { $0.billID == billID }.sorted { $0.date > $1.date }
    }

    /// Everything a member said on the floor, most recent first.
    func interventions(byMP mpID: String) -> [Speech] {
        speeches.filter { $0.mpID == mpID }.sorted { $0.date > $1.date }
    }

    /// Distinct members who spoke on a bill, most recent intervention first.
    func speakers(onBill billID: String) -> [MP] {
        var seen = Set<String>()
        return interventions(onBill: billID).compactMap { speech in
            guard seen.insert(speech.mpID).inserted else { return nil }
            return mp(id: speech.mpID)
        }
    }

    /// Schemes through which a bill's provisions are funded.
    func linkedSchemes(for bill: Bill) -> [BudgetScheme] {
        bill.linkedSchemeIDs.compactMap { scheme(id: $0) }
    }

    /// Bills whose provisions are funded through a given scheme.
    func linkedBills(forScheme schemeID: String) -> [Bill] {
        bills.filter { $0.linkedSchemeIDs.contains(schemeID) }
    }

    // MARK: - Aggregates

    var averageAttendance: Double {
        guard !mps.isEmpty else { return 0 }
        return mps.reduce(0) { $0 + $1.attendance } / Double(mps.count)
    }

    var totalAllocation: Double {
        schemes.reduce(0) { $0 + $1.totalAllocation }
    }

    var totalActual: Double {
        schemes.reduce(0) { $0 + $1.totalActual }
    }
}

// MARK: - Previews

extension ParliamentStore {
    /// A store already filled with the bundled records, for SwiftUI previews.
    static var preview: ParliamentStore {
        let store = ParliamentStore()
        store.useBundledData()
        store.followedBillIDs = [SampleData.bills[0].id]
        return store
    }
}
