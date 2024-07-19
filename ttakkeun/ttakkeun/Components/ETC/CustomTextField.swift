//
//  CustomTextField.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @FocusState private var isTextFocused: Bool
    
    let keyboardType: UIKeyboardType
    let placeHolder: String
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
        fontSize: CGFloat,
        cornerRadius: CGFloat,
        padding: CGFloat,
        showGlass: Bool,
        maxWidth: CGFloat,
        maxHeight: CGFloat
    ) {
        self.keyboardType = keyboardType
        self._text = text
        self.placeHolder = placeholder
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.showGlass = showGlass
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    // MARK: - Contents
    
    var body: some View {
        ZStack {
            
            placeholderInField
            
            inputOneLineTextField
                
        }
        .onTapGesture {
            isTextFocused = false
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var inputOneLineTextField: some View {
        TextField("", text: $text, axis: .horizontal)
            .frame(width: maxWidth - 40, height: maxHeight)
            .keyboardType(keyboardType)
            .font(.suit(type: .medium, size: fontSize))
            .foregroundStyle(Color.black)
            .focused($isTextFocused)
            .padding(.leading, padding)
            .background(Color.clear)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: 0.5)
                    .stroke(Color.borderGray_Color, lineWidth: 1)
            )
            .onTapGesture {
                if !isTextFocused {
                    text = ""
                    isTextFocused = true
                }
            }
    }
    
    /// placeholder 정의
    private var placeholderInField: some View {
        HStack(spacing: 2, content: {
                        if showGlass {
                            Icon.glass.image
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
            if text.isEmpty && !isTextFocused {
                Text(placeHolder)
                    .font(.suit(type: .medium, size: fontSize))
                    .foregroundStyle(Color.borderGray_Color)
                    .allowsHitTesting(false)
            }
        })
        .frame(width: maxWidth, height: maxHeight, alignment: .leading)
        .padding(.leading, 25)
        .onTapGesture {
            print("click")
            isTextFocused = true
        }
    }
}

struct CustomTextField_PreView: PreviewProvider {
    
    @State static var text: String = "가나다라마바사"
    
    static var previews: some View {
        CustomTextField(text: $text, placeholder: "검색어를 입력해주세요", fontSize: 16, cornerRadius: 10, padding: 44, showGlass: true, maxWidth: 331, maxHeight: 40)
    }
}
