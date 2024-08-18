//
//  CustomTextEditor.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/17/24.
//

import SwiftUI

/// 100자 이상 작성할 시 필요한 텍스트 에디터
struct CustomTextEditor: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    
    /// CustomtextEditor 초기값
    /// - Parameters:
    ///   - placeholder: 텍스트 에디터 내부 가이드 텍스트
    ///   - text: 입력 텍스트 값
    init(placeholder: String,
         text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(alignment: .topLeading, content: {
                if text.isEmpty {
                    Text(placeholder)
                        .lineSpacing(10)
                        .padding(20)
                        .padding(.top, 2)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray_400)
                }
            })
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled()
            .background(Color.scheduleCard_Color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.Body3_medium)
            .foregroundStyle(Color.gray_900)
            .scrollContentBackground(.hidden)
            .overlay(alignment: .bottomTrailing, content: {
                Text("\(text.count) / 150")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray_400)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .onChange(of: text) { newValue, oldValue in
                        if newValue.count > 150 {
                            text = String(newValue.prefix(150))
                        }
                    }
            })
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray200, lineWidth: 1)
                    .fill(Color.clear)
            )
    }
}

extension TextEditor {
    func customStyleEditor(placeholder: String, text: Binding<String>) -> some View {
        self.modifier(CustomTextEditor(placeholder: placeholder, text: text))
    }
}

struct CustomTextEditor_Preview: PreviewProvider {
    
    @State static var inputText = ""
    
    static var previews: some View {
        TextEditor(text: $inputText)
            .customStyleEditor(placeholder: "자세히 적어주세요! 정확한 진단 결과를 받아볼 수 있어요!", text: $inputText)
            .frame(width: 347, height: 204)
            .previewLayout(.sizeThatFits)
    }
}
