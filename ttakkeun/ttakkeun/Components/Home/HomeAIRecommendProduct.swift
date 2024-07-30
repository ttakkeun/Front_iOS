//
//  HomeRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI
import Kingfisher

/// AI 추천 제품 카드
struct HomeAIRecommendProduct: View {
    
    let data: ProductDetailData
    
    // MARK: - Init
    
    init(data: ProductDetailData) {
        self.data = data
    }
    
    // MARK: - Contents
    
    var body: some View {
        HStack(alignment: .center, spacing: 14, content: {
            productImage
            productInfo
        })
        .frame(maxWidth: 241, maxHeight: 92)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.gray_200, lineWidth: 1)
        )
    }
    
    /// 추천 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure{ _ in
                    print("AI 추천 상품 이미지 로딩 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 62, maxHeight: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    /// 추천 상품 가격과 제목 정보
    @ViewBuilder
    private var productInfo: some View {
        /* 가격 쉼표 표시 */
        var formattedPrice: String {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                return formatter.string(from: NSNumber(value: data.price)) ?? "\(data.price)"
            }
        
        
        VStack(alignment: .leading, spacing: 6) {
            Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
                .font(.suit(type: .semibold, size: 14))
                .foregroundStyle(Color.gray_900)
                .lineLimit(nil)
                .lineSpacing(1.5)
            Text("\(formattedPrice)원")
                .font(.suit(type: .bold, size: 16))
                .foregroundStyle(Color.gray_900)
        }
        .frame(maxWidth: 137)
    }
}


// MARK: - Preview

struct HomeRecommendProduct_Preview: PreviewProvider {
    static var previews: some View {
        HomeAIRecommendProduct(data: ProductDetailData(productId: 1, title: "아껴주다 저자극 천연 고양이 샴푸", image: "https://shopping-phinf.pstatic.net/main_8516432/85164327357.jpg", price: 12000, brand: "쿠팡", purchaseLink: "https://smartstore.naver.com/main/products/7619827035", category1: "건강", category2: "샴푸", category3: "목록", category4: "몰라요", totalLike: 0, likeStatus: true))
            .previewLayout(.sizeThatFits)
    }
}
