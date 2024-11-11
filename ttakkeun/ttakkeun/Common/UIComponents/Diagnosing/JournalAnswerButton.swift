//
//  JournalAnswerButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalAnswerButton: View {
    
    @Binding var isSelected: Bool
    let data: AnswerDetailData
    let onSelect: () -> Void
    
    init(
        isSelected: Binding<Bool>,
        data: AnswerDetailData,
        _ onSelect: @escaping () -> Void
    ) {
        self._isSelected = isSelected
        self.data = data
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            onSelect()
        }, label: {
            buttonContents
        })
    }
    
    private var buttonContents: some View {
        HStack(alignment: .center, content: {
            Text(data.answerText)
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
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
        .padding([.leading, .bottom], 28)
        .padding(.top, 29)
        .padding(.trailing, 24)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.primarycolor200 : Color.answerBg)
        }
    }
}

struct JournalAnswerButton_Preview: PreviewProvider {
    static var previews: some View {
        JournalAnswerButton(isSelected: .constant(true), data: AnswerDetailData(answerID: UUID(), answerText: "윤기가 나요"), { print("hello") })
    }
}
