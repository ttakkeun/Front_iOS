//
//  CustomTextField.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @FocusState private var isTextFocused: Bool
    
    let keyboardType: UIKeyboardType
    let placeholder: String
    let fontSize: CGFloat
    let cornerRadius: CGFloat
    let padding: CGFloat
    let showGlass: Bool
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    // MARK: - Init
    
    /// 커스텀 텍스트필드 초기화
    /// - Parameters:
    ///   - keyboardType: 입력 키도브 값
    ///   - text: 입력 값
    ///   - isTextFocused: 텍스트 필드의 초점
    ///   - placeholder: 가이드 표시
    ///   - cornerRadius: radius 값
    ///   - showGlass: 돋보기 유무
    ///   - maxWidth: 가로 길이
    ///   - maxHeight: 세로 길이
    init(
        keyboardType: UIKeyboardType = .default,
        text: Binding<String>,
        isTextFocused: Bool = false,
        placeholder: String,
        fontSize: CGFloat = 14,
        cornerRadius: CGFloat = 10,
        padding: CGFloat = 15,
        showGlass: Bool = false,
        maxWidth: CGFloat = 341,
        maxHeight: CGFloat = 44
    ) {
        self.keyboardType = keyboardType
        self._text = text
        self.placeholder = placeholder
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.showGlass = showGlass
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        ZStack {
            
            placeholderInField
            
            inputOutLineTextField
                
        }
        .onTapGesture {
            isTextFocused = false
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth: maxWidth)
    }
    
    private var inputOutLineTextField: some View {
        TextField("", text: $text, axis: .horizontal)
            .frame(width: maxWidth , height: maxHeight)
            .font(.suit(type: .medium, size: fontSize))
            .foregroundStyle(Color.black)
            .focused($isTextFocused)
            .padding(.leading, padding)
            .background(Color.clear)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(content: {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: 0.5)
                    .stroke(Color.gray200, lineWidth: 1)
                    .frame(width: maxWidth)
            })
            .onTapGesture {
                if !isTextFocused {
                    text = ""
                    isTextFocused = true
                }
            }
    }
    
    private var placeholderInField: some View {
        HStack(spacing: 2, content: {
            if showGlass {
                Icon.glass.image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 15)
            }
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .frame(height: 18)
                    .font(.suit(type: .medium, size: fontSize))
                    .foregroundStyle(Color.gray200)
                    .allowsHitTesting(false)
                    .padding(.leading, 15)
                    .padding(.vertical, 13)
            }
        })
        .frame(width: maxWidth, height: maxHeight, alignment: .leading)
        .onTapGesture {
            print("click")
            isTextFocused = true
        }
    }
}
