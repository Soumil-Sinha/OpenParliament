//
//  BudgetDetailView.swift
//  OpenParliament
//

import SwiftUI

struct BudgetDetailView: View {
    let scheme: BudgetScheme
    @Environment(ParliamentStore.self) private var store

    private var linkedBills: [Bill] { store.linkedBills(forScheme: scheme.id) }

    var body: some View {
        List {
            headerSection
            figuresSection
            yearSection
            auditSection
            legislationSection
        }
        .listStyle(.plain)
        .navigationTitle("Scheme")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(scheme.sector.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(0.7)
                    .foregroundStyle(.secondary)

                Text(scheme.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)

                Text(scheme.ministry)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(scheme.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
        }
    }

    private var figuresSection: some View {
        Section {
            StatRow {
                StatTile(
                    value: scheme.totalAllocation.croreFormatted,
                    label: "Allocated",
                    caption: "4 years"
                )
                StatTile(
                    value: scheme.totalActual.croreFormatted,
                    label: "Spent",
                    emphasized: true,
                    caption: "\(scheme.utilisation.percentWhole) utilised"
                )
                StatTile(
                    value: scheme.unspent.croreFormatted,
                    label: "Unspent",
                    caption: "Against allocation"
                )
            }
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)

            SchemeSpendChart(scheme: scheme)
                .listRowSeparator(.hidden)
        } header: {
            SectionHeader("Allocation vs expenditure")
        } footer: {
            Text("Figures in ₹ crore, as per budget documents and appropriation accounts.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        }
    }

    private var yearSection: some View {
        Section {
            ForEach(scheme.years) { year in
                FiscalYearRow(year: year)
            }
        } header: {
            SectionHeader("By financial year")
        }
    }

    @ViewBuilder
    private var auditSection: some View {
        if let finding = scheme.cagFinding {
            Section {
                AuditNote(finding: finding)
                    .padding(.vertical, 4)
                    .listRowSeparator(.hidden)
            } header: {
                SectionHeader("Audit")
            } footer: {
                Text("Observations are reproduced from the referenced report and are not, by themselves, findings of impropriety.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
        }
    }

    private var legislationSection: some View {
        Section {
            if linkedBills.isEmpty {
                Text("No bill in this dataset funds this scheme.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ForEach(linkedBills) { bill in
                    NavigationLink(value: bill) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(bill.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            HStack(spacing: 6) {
                                Text(bill.stage.title)
                                Text("·")
                                Text(bill.billNumber)
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        } header: {
            SectionHeader("Enabling legislation")
        }
    }
}

#Preview("With audit note") {
    NavigationStack {
        BudgetDetailView(scheme: SampleData.schemes[0])
            .parliamentDestinations()
    }
    .environment(ParliamentStore.preview)
}

#Preview("No audit note") {
    NavigationStack {
        BudgetDetailView(scheme: SampleData.schemes[2])
            .parliamentDestinations()
    }
    .environment(ParliamentStore.preview)
}
