//
//  AIReccoomendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import SwiftUI
import UIKit
import Kingfisher

struct AIRecommendProductCard: View {
    
    let data: ProductResponse
    
    var body: some View {
        HStack(alignment: .center, spacing: 14, content: {
            productImage
            productInfo
        })
        .frame(width: 241, height: 92)
        .background(Color.clear)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.gray200, lineWidth: 1)
        })
    }
    
    /// 추천 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure{ _ in
                    print("AI 추천 상품 이미지 로딩 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 62, maxHeight: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(5)
        }
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(DataFormatter.shared.stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(2)
                .lineSpacing(1.5)
//                .truncationMode(.tail)
            
            Text("\(DataFormatter.shared.formattedPrice(from: data.price))원")
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
        })
        .frame(maxWidth: 137)
    }
}

struct AIRecommendedProductCard_Preview: PreviewProvider {
    static var previews: some View {
        AIRecommendProductCard(data: ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: nil, likeStatus: false))
    }
}
