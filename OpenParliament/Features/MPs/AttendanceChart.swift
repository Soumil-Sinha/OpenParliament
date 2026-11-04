//
//  AttendanceChart.swift
//  OpenParliament
//

import Charts
import SwiftUI

/// Attendance across the recorded sessions. The line and its points are the
/// only accent-coloured marks; the member's average is a gray dashed rule.
struct AttendanceChart: View {
    let history: [SessionAttendance]
    let average: Double

    var body: some View {
        Chart {
            ForEach(history) { record in
                LineMark(
                    x: .value("Session", record.shortLabel),
                    y: .value("Attendance", record.attendance)
                )
                .foregroundStyle(Theme.accent)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.monotone)

                PointMark(
                    x: .value("Session", record.shortLabel),
                    y: .value("Attendance", record.attendance)
                )
                .foregroundStyle(Theme.accent)
                .symbolSize(26)
            }

            RuleMark(y: .value("Average", average))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .foregroundStyle(Theme.chartNeutral)
        }
        .chartYScale(domain: 40...100)
        .chartYAxis {
            AxisMarks(position: .leading, values: [40.0, 60, 80, 100]) { value in
                AxisGridLine().foregroundStyle(Theme.hairline)
                AxisValueLabel {
                    if let percent = value.as(Double.self) {
                        Text("\(Int(percent))")
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
        .frame(height: 150)
        .padding(.vertical, 8)
        .accessibilityLabel("Attendance by session")
        .accessibilityValue(
            history
                .map { "\($0.session), \(Int($0.attendance)) percent" }
                .joined(separator: ". ")
        )
    }
}

#Preview {
    let mp = SampleData.mps[3]
    return AttendanceChart(history: mp.attendanceHistory, average: mp.attendance)
        .padding()
}
