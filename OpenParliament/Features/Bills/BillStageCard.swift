//
//  BillStageCard.swift
//  OpenParliament
//

import SwiftUI

/// Stepper, status sentence and the screen's one primary action.
struct BillStageCard: View {
    let stage: BillStage
    @Binding var isFollowing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StageStepper(current: stage)
                .padding(.top, 6)

            Text(stage.statusLine)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                isFollowing.toggle()
            } label: {
                Label(
                    isFollowing ? "Following this bill" : "Follow this bill",
                    systemImage: isFollowing ? "checkmark" : "bell"
                )
            }
            .buttonStyle(AccentButtonStyle(prominent: !isFollowing))
        }
        .padding(.bottom, 4)
    }
}

private struct BillStageCardPreview: View {
    @State private var isFollowing = false

    var body: some View {
        BillStageCard(stage: .committee, isFollowing: $isFollowing)
            .padding()
    }
}

#Preview {
    BillStageCardPreview()
}
