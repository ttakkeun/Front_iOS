//
//  AnswerButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import SwiftUI

/// 질문에 관한 답변 선택 버튼
struct AnswerButton: View {
    
    @Binding var isSelected: Bool
    let data: AnswerDetailData
    let allowMultipleSection: Bool
    let onSelect: () -> Void
    
    
    // MARK: - Init
    
    init(
        isSelected: Binding<Bool>,
        data: AnswerDetailData,
        allowMultipleSection: Bool = false,
        _ onSelect: @escaping () -> Void
    ) {
        self._isSelected = isSelected
        self.data = data
        self.allowMultipleSection = allowMultipleSection
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            onSelect()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.primarycolor_200 : Color.scheduleCard_Color)
                    .frame(width: 353, height: 87)
                
                buttonContents
            }
        })
    }
    
    // MARK: - Contents
    
    /// 질문의 ID에 맞는 답변 버튼 자동 생성 컴포넌트
    private var buttonContents: some View {
        HStack(alignment: .center, content: {
            Text(data.answerText)
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray_900)
            
            Spacer()
            
            if isSelected {
                Icon.answerCheck.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            } else {
                Icon.answerNotCheck.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        })
        .frame(width: 301, height: 30)
    }
}
