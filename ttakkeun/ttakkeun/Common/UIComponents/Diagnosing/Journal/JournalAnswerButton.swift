//
//  JournalAnswerButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalAnswerButton: View {
    
    // MARK: - Property
    @Binding var isSelected: Bool
    let paddingValue: [CGFloat]
    let data: AnswerDetailData
    let onSelect: () -> Void
    
    // MARK: - Constants
    fileprivate enum JournalAnswerConstants {
        static let lineSpacing: CGFloat = 2
        static let cornerRadius: CGFloat = 10
        static let imageSize: CGFloat = 30
    }
    
    // MARK: - Init
    init(
        isSelected: Binding<Bool>,
        paddingValue: [CGFloat] = [29, 28, 28, 24],
        data: AnswerDetailData,
        _ onSelect: @escaping () -> Void
    ) {
        self._isSelected = isSelected
        self.paddingValue = paddingValue
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
    
    /// 버튼 모양
    private var buttonContents: some View {
        HStack(alignment: .center, content: {
            Text(data.answerText)
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .lineSpacing(JournalAnswerConstants.lineSpacing)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            isSelectedButton
        })
        .padding(.top, paddingValue[0])
        .padding(.bottom, paddingValue[1])
        .padding(.leading, paddingValue[2])
        .padding(.trailing, paddingValue[3])
        .background {
            RoundedRectangle(cornerRadius: JournalAnswerConstants.cornerRadius)
                .fill(isSelected ? Color.primarycolor200 : Color.answerBg)
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var isSelectedButton: some View {
        let image = isSelected ? Image(.answerCheck) : Image(.answerNotCheck)
        
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: JournalAnswerConstants.imageSize, height: JournalAnswerConstants.imageSize)
    }
}

struct JournalAnswerButton_Preview: PreviewProvider {
    static var previews: some View {
        JournalAnswerButton(isSelected: .constant(true), data: AnswerDetailData(answerID: UUID(), answerText: "asdasjkdhakjshdkjashdkjasdhakjsdhjaskdjhdk 나요"), { print("hello") })
    }
}
