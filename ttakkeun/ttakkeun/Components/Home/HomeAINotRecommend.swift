//
//  HomeAINotRecommend.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/29/24.
//

import SwiftUI

/// AI 상품 없을 시 사용하는 컴포넌트
struct HomeAINotRecommend: View {
    var body: some View {
        notRecommendedView
    }
    
    // MARK: - Components
    
    private var notRecommendedView: some View {
        VStack(alignment: .center, spacing: 3, content: {
            warningText(text: "AI 추천 제품이 아직 없어요!")
            warningText(text: "일지를 작성하고 AI 진단을 받으러 가볼까요?")
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

#Preview {
    HomeAINotRecommend()
        .previewLayout(.sizeThatFits)
}
