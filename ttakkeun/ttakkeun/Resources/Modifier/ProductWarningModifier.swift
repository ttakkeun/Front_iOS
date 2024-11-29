//
//  ProductWarningModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import Foundation
import SwiftUI

struct ProductWarningModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 212, height: 50)
            .padding(.vertical, 31)
            .padding(.horizontal, 69)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .stroke(Color.gray200, lineWidth: 1)
            )
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
            .lineSpacing(1.8)
            .multilineTextAlignment(.center)
    }
}
