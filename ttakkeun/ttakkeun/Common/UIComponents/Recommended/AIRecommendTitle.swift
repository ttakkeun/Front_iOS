//
//  AIRecommendTitle.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import SwiftUI

/// AI 최근 추천 타이틀
struct AIRecommendTitle: View {
    
    // MARK: - Property
    let title: String
    
    fileprivate enum AIRecommendConstants {
        static let hSpacing: CGFloat = 4
    }
    
    // MARK: - Init
    init(title: String) {
        self.title = title
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: AIRecommendConstants.hSpacing, content: {
            Image(.recommendDog)
            
            Text(title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
    }
}
