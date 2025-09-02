//
//  NotRecommend.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import SwiftUI

struct NotRecommend: View {
    
    // MARK: - Property
    let recommendType: RecommendType
    
    // MARK: - Constants
    fileprivate enum NotRecommendConstants {
        static let height: CGFloat = 94
        static let cornerRadius: CGFloat = 10
        static let lineSpacing: CGFloat = 2.0
        static let aiWarningText: String = "AI 추천 제품이 아직 없어요! \n일지를 작성하고 AI 진단을 받으러 가볼까요?"
        static let userWarningText: String = "유저 추천 제품이 아직 없어요! \n다른 유저들의 추천 제품을 기다려 주세요!"
        static let noMyScrapTipText: String = "아직 스크랩한 게시글이 없네요 👀 \n마음에 드는 글을 발견하면 바로 스크랩해보세요!"
        static let noMyWriteTip: String = "아직 작성한 게시글이 없네요 ✍️ \n 지금 바로 첫 글을 남겨보세요!"
    }
    // MARK: - Init
    init(recommendType: RecommendType) {
        self.recommendType = recommendType
    }
    
    // MARK: - Body
    var body: some View {
        switch recommendType {
        case .aiRecommend:
            warningText(text: NotRecommendConstants.aiWarningText)
        case .userRecommend:
            warningText(text: NotRecommendConstants.userWarningText)
        case .noMyScrapTip:
            warningText(text: NotRecommendConstants.noMyScrapTipText)
        case .noMyWriteTip:
            warningText(text: NotRecommendConstants.noMyWriteTip)
        }
    }
    
    private func warningText(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: NotRecommendConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
                .frame(maxWidth: .infinity)
                .frame(height: NotRecommendConstants.height)
            
            Text(text)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .lineSpacing(NotRecommendConstants.lineSpacing)
                .multilineTextAlignment(.center)
        }
    }
}

enum RecommendType: String {
    case aiRecommend
    case userRecommend
    case noMyScrapTip
    case noMyWriteTip
}

struct NotRecommend_Preview: PreviewProvider {
    static var previews: some View {
        NotRecommend(recommendType: .userRecommend)
    }
}
