//
//  SchemeSpendChart.swift
//  OpenParliament
//

import Charts
import SwiftUI

/// Allocation against actual expenditure, one pair of bars per financial year.
/// Allocation is gray; the accent is reserved for what was actually spent.
struct SchemeSpendChart: View {
    let scheme: BudgetScheme

    var body: some View {
        Chart(scheme.spendPoints) { point in
            BarMark(
                x: .value("Financial year", point.yearLabel),
                y: .value("₹ crore", point.amount)
            )
            .position(by: .value("Series", point.series.rawValue))
            .foregroundStyle(by: .value("Series", point.series.rawValue))
            .cornerRadius(2)
        }
        .chartForegroundStyleScale([
            SpendSeries.allocation.rawValue: Theme.chartNeutral,
            SpendSeries.actual.rawValue: Theme.accent
        ])
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine().foregroundStyle(Theme.hairline)
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(amount.croreAxisLabel)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                // Color.secondary, not .secondary — the hierarchical style would
                // resolve against the chart's tint and come out pale blue.
                AxisValueLabel()
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
        }
        .chartLegend(position: .bottom, alignment: .leading, spacing: 12)
        .frame(height: 190)
        .padding(.vertical, 8)
        .accessibilityLabel("Allocation compared with actual expenditure by financial year")
        .accessibilityValue(
            scheme.years
                .map { "\($0.fullLabel): allocated \($0.allocation.croreFormatted), spent \($0.actual.croreFormatted)" }
                .joined(separator: ". ")
        )
    }
}

#Preview {
    SchemeSpendChart(scheme: SampleData.schemes[0])
        .padding()
}
