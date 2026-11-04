//
//  SampleSchemes.swift
//  OpenParliament
//

import Foundation

extension SampleData {

    static let schemes: [BudgetScheme] = [
        BudgetScheme(
            id: "scheme-health",
            name: "Rural Health Access Mission",
            sector: "Health & Family Welfare",
            ministry: "Ministry of Health & Family Welfare",
            summary: """
                Funds diagnostic equipment, sub-centre staffing and patient transport in districts \
                identified as underserved. Released to states in two tranches against verified \
                staffing returns.
                """,
            years: [
                FiscalYearSpend(label: "FY22", fullLabel: "2021–22", allocation: 9_800, actual: 8_240),
                FiscalYearSpend(label: "FY23", fullLabel: "2022–23", allocation: 11_200, actual: 9_760),
                FiscalYearSpend(label: "FY24", fullLabel: "2023–24", allocation: 12_500, actual: 10_910),
                FiscalYearSpend(label: "FY25", fullLabel: "2024–25", allocation: 13_000, actual: 12_180)
            ],
            cagFinding: CAGFinding(
                reference: "CAG Report No. 9 of 2025 (Performance Audit), Para 4.7",
                note: """
                    Utilisation certificates for 14 district units were still pending at the close of \
                    2024–25. Audit attributes the gap to delays in releasing the second tranche rather \
                    than to a shortfall in sanctioned funds.
                    """
            )
        ),
        BudgetScheme(
            id: "scheme-rivers",
            name: "National River Rejuvenation Programme",
            sector: "Water Resources",
            ministry: "Ministry of Jal Shakti",
            summary: """
                Capital support for sewage interception and treatment along eleven river stretches, \
                plus monitoring stations that report effluent load to a public dashboard.
                """,
            years: [
                FiscalYearSpend(label: "FY22", fullLabel: "2021–22", allocation: 6_400, actual: 4_980),
                FiscalYearSpend(label: "FY23", fullLabel: "2022–23", allocation: 7_100, actual: 5_320),
                FiscalYearSpend(label: "FY24", fullLabel: "2023–24", allocation: 8_200, actual: 6_050),
                FiscalYearSpend(label: "FY25", fullLabel: "2024–25", allocation: 8_800, actual: 7_240)
            ],
            cagFinding: CAGFinding(
                reference: "CAG Report No. 3 of 2025, Para 2.11",
                note: """
                    Treatment capacity commissioned in 2023–24 stood at 61 per cent of the target in the \
                    sanctioned project reports. Audit attributes most of the gap to land acquisition \
                    timelines in three states.
                    """
            )
        ),
        BudgetScheme(
            id: "scheme-grid",
            name: "Grid Modernisation & Storage Fund",
            sector: "Power",
            ministry: "Ministry of Power",
            summary: """
                Viability gap funding for battery storage co-located with renewable capacity, and \
                upgrades to state load despatch centres for forecasting and scheduling.
                """,
            years: [
                FiscalYearSpend(label: "FY22", fullLabel: "2021–22", allocation: 3_900, actual: 3_610),
                FiscalYearSpend(label: "FY23", fullLabel: "2022–23", allocation: 4_600, actual: 4_470),
                FiscalYearSpend(label: "FY24", fullLabel: "2023–24", allocation: 5_400, actual: 5_180),
                FiscalYearSpend(label: "FY25", fullLabel: "2024–25", allocation: 6_100, actual: 5_940)
            ],
            cagFinding: nil
        ),
        BudgetScheme(
            id: "scheme-dpi",
            name: "Digital Public Infrastructure Fund",
            sector: "Electronics & IT",
            ministry: "Ministry of Electronics & Information Technology",
            summary: """
                Supports identity, payments and consent infrastructure operated as public utilities, \
                including the grievance redress systems that sit alongside them.
                """,
            years: [
                FiscalYearSpend(label: "FY22", fullLabel: "2021–22", allocation: 2_400, actual: 1_760),
                FiscalYearSpend(label: "FY23", fullLabel: "2022–23", allocation: 3_100, actual: 2_240),
                FiscalYearSpend(label: "FY24", fullLabel: "2023–24", allocation: 3_600, actual: 2_610),
                FiscalYearSpend(label: "FY25", fullLabel: "2024–25", allocation: 4_200, actual: 3_380)
            ],
            cagFinding: CAGFinding(
                reference: "CAG Report No. 12 of 2025, Para 5.2",
                note: """
                    ₹1,180 crore released to two implementing agencies remained unspent in \
                    interest-bearing accounts beyond the permitted 90 days. The agencies have since \
                    reported the accrued interest back to the consolidated fund.
                    """
            )
        )
    ]
}
