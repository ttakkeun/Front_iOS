//
//  HomeAINotRecommend.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/29/24.
//

import SwiftUI

struct HomeAINotRecommend: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    // MARK: - Components
    
    private var notRecommendedView: some View {
        VStack(alignment: .center, spacing: 3, content: {
        })
    }
    
    private func warningText() -> some View {
        Text("AI 추천 제품이 아직 없어요!")
    }
}

#Preview {
    HomeAINotRecommend()
}
