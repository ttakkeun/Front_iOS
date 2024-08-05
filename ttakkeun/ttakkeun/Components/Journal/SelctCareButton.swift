//
//  SelctCareButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

struct SelctCareButton: View {
    
    var partItem: PartItem
    
    init(partItem: PartItem) {
        self.partItem = partItem
    }
    
    var body: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray_600, lineWidth: 1)
                .frame(width: 126, height: 126)
            
            buttonImage
                .frame(width: 83, height: 74)
                .background(
                    Circle()
                        .fill(buttonColor())
                        .frame(width: 99, height: 99)
                )
        })
        .frame(width: 126, height: 126)
    }
    
    @ViewBuilder
    private var buttonImage: some View {
        switch partItem {
        case .ear:
            Icon.buttonEar.image
        case .eye:
            Icon.buttonEye.image
        case .hair:
            Icon.buttonHair.image
        case .claw:
            Icon.buttonClaw.image
        case .tooth:
            Icon.buttonTeeth.image
        }
    }
    
    private func buttonColor() -> Color {
        switch self.partItem {
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
}

struct SelectCareButton_Preview: PreviewProvider {
    static var previews: some View {
        SelctCareButton(partItem: .claw)
            .previewLayout(.sizeThatFits)
    }
}
