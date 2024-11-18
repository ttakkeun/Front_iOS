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
    
    init(text: Binding<String>,
         placeholder: String,
         maxTextCount: Int
    ) {
        self._text = text
        self.placeholder = placeholder
        self.maxTextCount = maxTextCount
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 25)
            .padding(.horizontal, 17)
            .background(alignment: .topLeading, content: {
                if text.isEmpty {
                    Text(placeholder)
                        .lineSpacing(10)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 17)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray400)
                }
            })
            .textInputAutocapitalization(.none)
            .background(Color.answerBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
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
                    .stroke(Color.gray200, lineWidth: 1)
                    .fill(Color.clear)
            )
    }
}

extension TextEditor {
    func customStyleEditor(text: Binding<String>, placeholder: String, maxTextCount: Int) -> some View {
        self.modifier(CustomTextEditor(text: text, placeholder: placeholder, maxTextCount: maxTextCount))
    }
}
