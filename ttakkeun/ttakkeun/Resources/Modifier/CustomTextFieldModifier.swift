//
//  CustomTextFieldModifier.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/9/25.
//

import Foundation
import SwiftUI

struct ttakkeunTextFieldStyle: TextFieldStyle {
    
    let leadingPadding: CGFloat = 15
    let trailingPadding: CGFloat = 13
    let cornerRadius: CGFloat = 10
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, leadingPadding)
            .padding(.vertical, trailingPadding)
            .font(.Body3_medium)
            .foregroundStyle(.gray900)
            .overlay(content: {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200, style: .init())
            })
    }
}
