//
//  SelctCareButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

/// 진단 항목 선택 버튼 뷰
struct SelctCareButton: View {
    
    var partItem: PartItem
    @Binding var selectedPart: PartItem?
    @State private var animateWave: Bool = false
    
    init(
        partItem: PartItem,
        selectedPart: Binding<PartItem?>
    ) {
        self.partItem = partItem
        self._selectedPart = selectedPart
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedPart = partItem
                animateWave = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animateWave = false
                }
            }
        }, label: {
            VStack(alignment: .center, spacing: 4) {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedPart == partItem ? buttonColor() : Color.clear)
                        .stroke(selectedPart == partItem ? strokeColor() : Color.gray_600, lineWidth: 1)
                        .frame(width: 126, height: 126)
                        .scaleEffect(selectedPart == partItem ? (animateWave ? 1.1 : 1.0) : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: animateWave)
                        .shadow03()
                    
                    buttonImage
                        .frame(width: 83, height: 74)
                        .background(
                            Circle()
                                .fill(selectedPart == partItem ? Color.clear : buttonColor())
                                .frame(width: 99, height: 99)
                        )
                })
                
                Text(partItem.toKorean())
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray_900)
            }
            .frame(width: 126, height: 148)
        })
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
    
    private func strokeColor() -> Color {
        switch self.partItem {
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
}
