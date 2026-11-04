//
//  ParliamentDestinations.swift
//  OpenParliament
//

import SwiftUI

/// Registers the three record types on a navigation stack so any list can push
/// any detail screen — including across kinds: bill → member, bill → scheme,
/// scheme → bill.
struct ParliamentDestinations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: MP.self) { MPProfileView(mp: $0) }
            .navigationDestination(for: Bill.self) { BillDetailView(bill: $0) }
            .navigationDestination(for: BudgetScheme.self) { BudgetDetailView(scheme: $0) }
    }
}

extension View {
    func parliamentDestinations() -> some View {
        modifier(ParliamentDestinations())
    }
}
