//
//  RecommendProductbyAI.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI
import Kingfisher

/// AI 추천 제품 카드
struct RecommendProductbyAI: View {
    
    let data: RecommenProductResponseData
    
    // MARK: - Init
    
    init(data: RecommenProductResponseData) {
        self.data = data
    }
    
    // MARK: - Contents
    
    var body: some View {
        HStack(alignment: .center, spacing: 14, content: {
            productImage
            productInfo
        })
        .frame(width: 213, height: 64)
        .padding(20)
        .background(Color.primarycolor400)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 10))
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
        
        
        VStack(alignment: .leading, spacing: 5) {
            Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray_900)
                .lineLimit(nil)
                .lineSpacing(1.5)
            Text("\(formattedPrice)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray_900)
        }
        .frame(maxWidth: 137)
    }
}


// MARK: - Preview

//MARK: - Components
struct RecommendProductbyAI_Preview: PreviewProvider {
    static var previews: some View {
        RecommendProductbyAI(data: RecommenProductResponseData(product_id: 1, title: "아껴주다 저자극 천연 고양이 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg", price: 13000, brand: "지강", link: "https://smartstore.naver.com/main/products/7619827035", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 123, isLike: true))
            .previewLayout(.sizeThatFits)
    }
}
