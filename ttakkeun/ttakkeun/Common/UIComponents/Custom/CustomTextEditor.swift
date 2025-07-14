//
//  CustomTextEditor.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

struct CustomTextEditor: ViewModifier {
    
    @Binding var text: String
    let placeholder: String
    let maxTextCount: Int
    let strokeColor: Color
    let backgroundColor: Color
    
    init(text: Binding<String>,
         placeholder: String,
         maxTextCount: Int
    ) {
        self._text = text
        self.placeholder = placeholder
        self.maxTextCount = maxTextCount
        self.strokeColor = Color.gray200
        self.backgroundColor = Color.answerBg
    }
    
    init(
        text: Binding<String>,
        placeholder: String,
        maxTextCount: Int,
        strokeColor: Color
    ) {
        self._text = text
        self.placeholder = placeholder
        self.maxTextCount = maxTextCount
        self.strokeColor = strokeColor
        self.backgroundColor = Color.answerBg
    }
    
    init(text: Binding<String>,
         placeholder: String,
         maxTextCount: Int,
         backgroundColor: Color
    ) {
        self._text = text
        self.placeholder = placeholder
        self.maxTextCount = maxTextCount
        self.strokeColor = Color.gray200
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 20)
            .padding(.horizontal, 17)
            .background(alignment: .topLeading, content: {
                if text.isEmpty {
                    Text(placeholder)
                        .lineSpacing(1.0)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 17)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray400)
                }
            })
            .textInputAutocapitalization(.none)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
            .lineSpacing(2.5)
            .scrollContentBackground(.hidden)
            .overlay(alignment: .bottomTrailing, content: {
                Text("\(text.count) / \(maxTextCount)")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .onChange(of: text) { newValue, oldValue in
                        if newValue.count > maxTextCount {
                            text = String(newValue.prefix(maxTextCount))
                        }
                    }
            })
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(strokeColor, lineWidth: 1)
                    .fill(Color.clear)
            )
    }
}

extension TextEditor {
    func customStyleEditor(text: Binding<String>, placeholder: String, maxTextCount: Int) -> some View {
        self.modifier(CustomTextEditor(text: text, placeholder: placeholder, maxTextCount: maxTextCount))
    }
    
    func customStyleTipsEditor(text: Binding<String>, placeholder: String, maxTextCount: Int, border: Color) -> some View {
        self.modifier(CustomTextEditor(text: text, placeholder: placeholder, maxTextCount: maxTextCount, strokeColor: border))
    }
    
    func customStyleTipsEditor(text: Binding<String>, placeholder: String, maxTextCount: Int, backColor: Color) -> some View {
        self.modifier(CustomTextEditor(text: text, placeholder: placeholder, maxTextCount: maxTextCount, backgroundColor: backColor))
    }
}

struct CustomTextEditor_Preview: PreviewProvider {
    
    @State static var inputText = ""
    
    static var previews: some View {
        TextEditor(text: $inputText)
            .customStyleEditor(text: $inputText, placeholder: "자세히 적어주세요! 정확한 진단 결과를 받아볼 수 있어요!", maxTextCount: 150)
            .frame(width: 347, height: 204)
            .previewLayout(.sizeThatFits)
    }
}
