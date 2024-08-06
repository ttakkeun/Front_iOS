//
//  AnswerButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import SwiftUI

struct AnswerButton: View {
    
    @Binding var isSelected: Bool
    let answerValue: AnswerValue
    let onSelect: () -> Void
    
    // MARK: - Init
    
    init(
        isSelected: Binding<Bool>,
        answerValue: AnswerValue,
        _ onSelect: @escaping () -> Void
    ) {
        self._isSelected = isSelected
        self.answerValue = answerValue
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            if isSelected {
                onSelect()
            }
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
    
    private var buttonContents: some View {
        HStack(alignment: .center, content: {
            Text(answerValue.rawValue)
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

struct AnswerButton_Preview: PreviewProvider {
    static var previews: some View {
        AnswerButton(isSelected: .constant(false), answerValue: .alopecia, {
            print("hello")
        })
        .previewLayout(.sizeThatFits)
    }
}
