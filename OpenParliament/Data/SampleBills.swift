//
//  SampleBills.swift
//  OpenParliament
//

import Foundation

extension SampleData {

    static let bills: [Bill] = [
        Bill(
            id: "bill-dpdp",
            title: "Digital Personal Data Protection (Amendment) Bill, 2025",
            billNumber: "Bill No. 118 of 2025",
            house: .lokSabha,
            ministry: "Ministry of Electronics & Information Technology",
            stage: .committee,
            summary: """
                Narrows the blanket exemption that lets government agencies process personal data \
                without consent, and requires every such exemption to be notified with reasons. \
                Also creates a licensed "consent manager" role so people can review and withdraw \
                permissions from one place instead of app by app.
                """,
            keyPoints: [
                "Government exemptions must be notified individually, with stated grounds.",
                "Consent managers are licensed and must offer a single withdrawal screen.",
                "Businesses below a turnover threshold get an 18-month compliance runway.",
                "Penalties are tiered by the volume of records affected, not by company size."
            ],
            stageHistory: [
                StageEvent(stage: .introduced, date: Fixture.date(2025, 3, 11),
                           detail: "Introduced in the Lok Sabha and taken up for first reading."),
                StageEvent(stage: .committee, date: Fixture.date(2025, 4, 2),
                           detail: "Referred to the Standing Committee on Information Technology.")
            ],
            linkedSchemeIDs: ["scheme-dpi"]
        ),
        Bill(
            id: "bill-water",
            title: "National Water Security and River Rejuvenation Bill, 2024",
            billNumber: "Bill No. 74 of 2024",
            house: .rajyaSabha,
            ministry: "Ministry of Jal Shakti",
            stage: .passed,
            summary: """
                Sets up river basin authorities that plan water use across state lines instead of \
                state by state. Basin plans become binding once notified, and states must publish \
                how much water each sector actually drew against its share every year.
                """,
            keyPoints: [
                "Basin authorities cover eleven interstate river systems.",
                "Annual sectoral drawdown figures must be published within 90 days of year end.",
                "Sewage treatment capacity targets are tied to the release of central funds.",
                "Disputes go to a standing tribunal rather than ad hoc benches."
            ],
            stageHistory: [
                StageEvent(stage: .introduced, date: Fixture.date(2024, 7, 22),
                           detail: "Introduced in the Rajya Sabha."),
                StageEvent(stage: .committee, date: Fixture.date(2024, 8, 19),
                           detail: "Examined by the Standing Committee on Water Resources; 26 amendments proposed."),
                StageEvent(stage: .passed, date: Fixture.date(2024, 12, 12),
                           detail: "Passed by both Houses with 14 committee amendments accepted.")
            ],
            linkedSchemeIDs: ["scheme-rivers"]
        ),
        Bill(
            id: "bill-health",
            title: "Public Health Infrastructure (Rural Access) Bill, 2023",
            billNumber: "Bill No. 41 of 2023",
            house: .lokSabha,
            ministry: "Ministry of Health & Family Welfare",
            stage: .enacted,
            summary: """
                Guarantees a minimum set of diagnostic services within 30 kilometres of every rural \
                habitation, and fixes staffing norms for sub-centres so a facility cannot be counted \
                as functional without the staff to run it.
                """,
            keyPoints: [
                "Twelve diagnostic tests must be available free at district level.",
                "A sub-centre counts as functional only with two resident health workers.",
                "District hospitals report bed occupancy and stock-outs monthly.",
                "Central funding is released in two tranches against verified staffing."
            ],
            stageHistory: [
                StageEvent(stage: .introduced, date: Fixture.date(2023, 2, 9),
                           detail: "Introduced in the Lok Sabha."),
                StageEvent(stage: .committee, date: Fixture.date(2023, 3, 6),
                           detail: "Standing Committee on Health & Family Welfare reported with minor changes."),
                StageEvent(stage: .passed, date: Fixture.date(2023, 7, 21),
                           detail: "Passed by both Houses."),
                StageEvent(stage: .enacted, date: Fixture.date(2023, 8, 14),
                           detail: "Received assent; notified as Act 22 of 2023.")
            ],
            linkedSchemeIDs: ["scheme-health"]
        ),
        Bill(
            id: "bill-grid",
            title: "Renewable Energy Grid Integration Bill, 2025",
            billNumber: "Bill No. 149 of 2025",
            house: .lokSabha,
            ministry: "Ministry of Power",
            stage: .introduced,
            summary: """
                Opens transmission access to independent storage operators and obliges distribution \
                companies to publish curtailment data — how much renewable power they turned away \
                and why — so that grid constraints can be located rather than assumed.
                """,
            keyPoints: [
                "Storage operators may seek open access on the same terms as generators.",
                "Curtailment events must be published within seven days, with reasons.",
                "A central settlement window covers deviation charges for storage.",
                "State load despatch centres publish forecast accuracy quarterly."
            ],
            stageHistory: [
                StageEvent(stage: .introduced, date: Fixture.date(2025, 7, 28),
                           detail: "Introduced in the Lok Sabha; first reading concluded.")
            ],
            linkedSchemeIDs: ["scheme-grid"]
        )
    ]
}
