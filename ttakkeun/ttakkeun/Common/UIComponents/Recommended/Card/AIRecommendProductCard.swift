//
//  AIReccoomendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import SwiftUI
import UIKit
import Kingfisher

/// AI제품 추천 카드
struct AIRecommendProductCard: View {
    
    // MARK: - Property
    @State private var loadFailed = false
    let data: ProductResponse
    
    // MARK: - Constants
    fileprivate enum AIRecommendConstants {
        static let mainHspacing: CGFloat = 14
        static let productVspacing: CGFloat = 6
        
        static let imageSize: CGFloat = 30
        static let imageWidth: CGFloat = 62
        static let imageHeight: CGFloat = 64
        static let textLineLimit: Int = 3
        static let lineSpacing: CGFloat = 1.5
        static let mainPadding: CGFloat = 14
        
        static let cardWidth: CGFloat = 280
        static let cardHeight: CGFloat = 92
        static let textHeight: CGFloat = 60
        
        static let maxCount: Int = 2
        static let retryInterval: TimeInterval = 2
        static let cornerRadius: CGFloat = 10
        static let defaultPadding: CGFloat = 5
        
        static let imagePlacholder: String = "questionmark.square.fill"
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: AIRecommendConstants.mainHspacing, content: {
            productImage
            productInfo
        })
        .frame(width: AIRecommendConstants.cardWidth)
        .padding(AIRecommendConstants.mainPadding)
        .background {
            RoundedRectangle(cornerRadius: AIRecommendConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
        }
    }
    
    /// 추천 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image), !loadFailed {
            KFImage(url)
                .placeholder {
                    notConnectUrlImage
                }.retry(maxCount: AIRecommendConstants.maxCount, interval: .seconds(AIRecommendConstants.retryInterval))
                .onFailure { _ in
                    loadFailed = true
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: AIRecommendConstants.imageWidth, maxHeight: AIRecommendConstants.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: AIRecommendConstants.cornerRadius))
                .padding(AIRecommendConstants.defaultPadding)
        } else {
            notConnectUrlImage
        }
    }
    
    /// URL 접속 실패 시 보이는 이미지
    private var notConnectUrlImage: some View {
        Image(systemName: AIRecommendConstants.imagePlacholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: AIRecommendConstants.imageWidth, maxHeight: AIRecommendConstants.imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: AIRecommendConstants.cornerRadius))
            .padding(AIRecommendConstants.defaultPadding)
    }
    
    /// 상품 설명
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: AIRecommendConstants.productVspacing, content: {
            Text(data.title.removingHTMLTags())
                .frame(height: AIRecommendConstants.textHeight, alignment: .top)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(AIRecommendConstants.textLineLimit)
                .lineSpacing(AIRecommendConstants.lineSpacing)
            
            Text("\(data.price)원")
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
        })
    }
}

struct AIRecommendedProductCard_Preview: PreviewProvider {
    static var previews: some View {
        AIRecommendProductCard(data: ProductResponse(productId: 1, title: "샤이닝펫 실키<b>헤어</b> 디탱글러 <b>강아지</b> 미스트 엉킨털 정리 정전기 윤기 보습 200ml, 1개", image: "xx", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: nil, likeStatus: false))
    }
}
