//
//  SelectCareItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct SelectCareItemButton: View {
    
    @State private var animateWave: Bool = false
    var partItemButton: PartItemButton
    
    init(partItemButton: PartItemButton) {
        self.partItemButton = partItemButton
    }
    
    
    var body: some View {
        Button(action: {
            withAnimation(.bouncy) {
                partItemButton.selectedPartItem = partItemButton.partItem
                animateWave = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animateWave = false
                }
            }
        }, label: {
            VStack(alignment: .center, spacing: 6, content: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(partItemButton.selectedPartItem == partItemButton.partItem ? partItemButton.partItem.toColor() : Color.clear)
                        .stroke(partItemButton.selectedPartItem == partItemButton.partItem ? partItemButton.partItem.toAfterColor() : Color.gray600, lineWidth: 1)
                        .scaleEffect(partItemButton.selectedPartItem == partItemButton.partItem ? (animateWave ? 1.1 : 1.0) : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: animateWave)
                        .shadow03()
                    
                    buttonImage()
                        .background {
                            Circle()
                                .fill(partItemButton.selectedPartItem == partItemButton.partItem ? Color.clear : partItemButton.partItem.toColor())
                                .frame(width: 99, height: 99)
                        }
                })
                Text(partItemButton.partItem.toKorean())
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
            })
            .frame(width: 126, height: 148)
        })
    }
}

extension SelectCareItemButton {
    func buttonImage() -> Image {
        switch partItemButton.partItem {
        case .ear:
            Icon.buttonEar.image
        case .eye:
            Icon.buttonEye.image
        case .hair:
            Icon.buttonHair.image
        case .claw:
            Icon.buttonClaw.image
        case .teeth:
            Icon.buttonTeeth.image
        }
    }
}

struct PartItemButton {
    let partItem: PartItem
    @Binding var selectedPartItem: PartItem?
}

struct SelectCareItemButton_Preview: PreviewProvider {
    static var previews: some View {
        SelectCareItemButton(partItemButton: PartItemButton(partItem: .ear, selectedPartItem: .constant(.ear)))
    }
}
