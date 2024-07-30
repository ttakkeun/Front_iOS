//
//  HomeNotTodoCircle.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// Init으로 원에 사진과 색 넣을 수 있도록 함
struct HomeTodoCircle: View {
    
    var partItem: PartItem
    var isBefore: Bool
    
    init(partItem: PartItem,
         isBefore: Bool
    ) {
        self.partItem = partItem
        self.isBefore = isBefore
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if isBefore {
                Circle()
                    .fill(beforeSetColor(partItem: self.partItem))
                    .frame(width: 50, height: 50)
            } else {
                Circle()
                    .fill(afterSetColor(partItem: self.partItem))
                    .frame(width: 50, height: 50)
            }
            setIcon(partItem: self.partItem)
                .fixedSize()
        }
    }
    
    // MARK: - Function
    
    private func beforeSetColor(partItem: PartItem) -> Color {
        switch partItem {
        case .ear:
            return Color.beforeEar_Color
        case .eye:
            return Color.beforeEye_Color
        case .hair:
            return Color.beforeHair_COlor
        case .claw:
            return Color.beforeClaw_Color
        case .tooth:
            return Color.beforeTeeth_Color
        }
    }
    
    private func afterSetColor(partItem: PartItem) -> Color {
        switch partItem {
        case .ear:
            return Color.afterEar_Color
        case .eye:
            return Color.afterEye_Color
        case .hair:
            return Color.afterHair_Color
        case .claw:
            return Color.afterClaw_Color
        case .tooth:
            return Color.afterTeeth_Color
        }
    }
    
    private func setIcon(partItem: PartItem) -> Image {
        switch partItem {
        case .ear:
            return Icon.homeEar.image
        case .eye:
            return Icon.homeEye.image
        case .hair:
            return Icon.homeHair.image
        case .claw:
            return Icon.homeClaw.image
        case .tooth:
            return Icon.homeTeeth.image
        }
    }
}
