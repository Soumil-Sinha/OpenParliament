//
//  StageStepper.swift
//  OpenParliament
//

import SwiftUI

/// Horizontal progress through the four stages of a bill. Completed and current
/// stages carry the accent; everything ahead stays gray.
struct StageStepper: View {
    let current: BillStage

    private var currentIndex: Int { current.rawValue }
    private var stages: [BillStage] { BillStage.allCases }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Array(stages.enumerated()), id: \.element) { index, stage in
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        connector(filled: index <= currentIndex)
                            .opacity(index == 0 ? 0 : 1)
                        marker(for: index)
                        connector(filled: index < currentIndex)
                            .opacity(index == stages.count - 1 ? 0 : 1)
                    }
                    Text(stage.title)
                        .font(.caption2)
                        .fontWeight(index == currentIndex ? .semibold : .regular)
                        .foregroundStyle(labelStyle(for: index))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress: \(current.title), stage \(currentIndex + 1) of \(stages.count)")
    }

    private func connector(filled: Bool) -> some View {
        Rectangle()
            .fill(filled ? Theme.accent : Theme.hairline)
            .frame(height: 1.5)
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func marker(for index: Int) -> some View {
        if index == currentIndex {
            // Current stage: filled dot inside a ring, so it reads as "here".
            Circle()
                .fill(Theme.accent)
                .frame(width: 11, height: 11)
                .padding(3)
                .overlay {
                    Circle().strokeBorder(Theme.accent.opacity(0.4), lineWidth: 1.5)
                }
        } else if index < currentIndex {
            Circle()
                .fill(Theme.accent)
                .frame(width: 9, height: 9)
                .padding(4)
        } else {
            Circle()
                .strokeBorder(Theme.hairline, lineWidth: 1.5)
                .frame(width: 9, height: 9)
                .padding(4)
        }
    }

    private func labelStyle(for index: Int) -> HierarchicalShapeStyle {
        if index == currentIndex { return .primary }
        return index < currentIndex ? .secondary : .tertiary
    }
}

#Preview {
    VStack(spacing: 28) {
        ForEach(BillStage.allCases) { stage in
            StageStepper(current: stage)
        }
    }
    .padding()
}
