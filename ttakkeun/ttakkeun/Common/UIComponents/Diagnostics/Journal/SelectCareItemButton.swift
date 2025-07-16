//
//  SelectCareItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 카테고리 선택 버튼(일지 등록 시 작성하기)
struct SelectCareItemButton: View {
    
    // MARK: - Property
    @State private var animateWave: Bool = false
    var partItemButton: PartItemButton
    
    // MARK: - Init
    init(partItemButton: PartItemButton) {
        self.partItemButton = partItemButton
    }
    
    // MARK: - Constants
    fileprivate enum SelectCareItemConstants {
        static let cornerRadius: CGFloat = 10
        static let buttonVspacing: CGFloat = 6
        static let animationTime: TimeInterval = 0.3
        static let minSize: CGFloat = 126
        static let imageSie: CGFloat = 99
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            withAnimation(.bouncy) {
                partItemButton.selectedPartItem = partItemButton.partItem
                animateWave = true
                DispatchQueue.main.asyncAfter(deadline: .now() + SelectCareItemConstants.animationTime) {
                    animateWave = false
                }
            }
        }, label: {
            VStack(alignment: .center, spacing: SelectCareItemConstants.buttonVspacing, content: {
                buttonShape
                
                buttonName
            })
        })
    }
    
    /// 버튼 모양
    private var buttonShape: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: SelectCareItemConstants.cornerRadius)
                .fill(partItemButton.selectedPartItem == partItemButton.partItem ? partItemButton.partItem.toColor() : Color.clear)
                .stroke(partItemButton.selectedPartItem == partItemButton.partItem ? partItemButton.partItem.toAfterColor() : Color.gray600, style: .init())
                .frame(minWidth: SelectCareItemConstants.minSize)
                .frame(height: SelectCareItemConstants.minSize)
                .scaleEffect(partItemButton.selectedPartItem == partItemButton.partItem ? (animateWave ? 1.1 : 1.0) : 1.0)
                .animation(.easeInOut(duration: SelectCareItemConstants.animationTime), value: animateWave)
                .shadow03()
            
            partItemButton.partItem.toButtonImage()
                .background {
                    Circle()
                        .fill(partItemButton.selectedPartItem == partItemButton.partItem ? Color.clear : partItemButton.partItem.toColor())
                        .frame(width: SelectCareItemConstants.imageSie, height: SelectCareItemConstants.imageSie)
                }
        })
    }
    
    /// 버튼 이름
    private var buttonName: some View {
        Text(partItemButton.partItem.toKorean())
            .font(.Body3_semibold)
            .foregroundStyle(Color.gray900)
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
