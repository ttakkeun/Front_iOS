//
//  SearchViewModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import Foundation
import SwiftUI

struct SearchViewModifier: ViewModifier {
    
    let lineSpacing: CGFloat = 10
    let cornerRadius: CGFloat = 10
    let verticalPadding: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
            .multilineTextAlignment(.center)
            .lineSpacing(lineSpacing)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, verticalPadding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200, style: .init())
            }
    }
}


