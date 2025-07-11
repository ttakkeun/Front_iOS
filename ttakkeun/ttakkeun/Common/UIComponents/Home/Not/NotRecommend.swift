//
//  NotRecommend.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import SwiftUI

struct NotRecommend: View {
    
    let recommendType: RecommendType
    
    init(recommendType: RecommendType) {
        self.recommendType = recommendType
    }
    
    var body: some View {
        switch recommendType {
        case .aiRecommend:
            warningText(text: "AI 추천 제품이 아직 없어요! \n일지를 작성하고 AI 진단을 받으러 가볼까요? ")
        case .userRecommend:
            warningText(text: "유저 추천 제품이 아직 없어요! \n다른 유저들의 추천 제품을 기다려 주세요!")
        }
        
    }
    
    private func warningText(text: String) -> some View {
        Text(text)
            .modifier(ProductWarningModifier())
    }
}

enum RecommendType: String {
    case aiRecommend
    case userRecommend
}

struct NotRecommend_Preview: PreviewProvider {
    static var previews: some View {
        NotRecommend(recommendType: .userRecommend)
    }
}
