//
//  HomeAINotRecommend.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/29/24.
//

import SwiftUI

/// AI 상품 없을 시 사용하는 컴포넌트
struct HomeNotRecommend: View {
    
    let firstLine: String
    let secondLine: String
    
    init(firstLine: String, secondLine: String) {
        self.firstLine = firstLine
        self.secondLine = secondLine
    }
    
    var body: some View {
        notRecommendedView
    }
    
    // MARK: - Components
    
    private var notRecommendedView: some View {
        VStack(alignment: .center, spacing: 3, content: {
            warningText(text: firstLine)
            warningText(text: secondLine)
        })
        .frame(width: 212, height: 32)
        .padding(.vertical, 31)
        .padding(.horizontal, 69)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.gray_200, lineWidth: 1)
        )
    }
    
    private func warningText(text: String) -> some View {
        Text(text)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_400)
    }
}
