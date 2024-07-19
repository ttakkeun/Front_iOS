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
    
    let productData: AIRecommendProductResponseData
    
    // MARK: - Init
    
    init(productData: AIRecommendProductResponseData) {
        self.productData = productData
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
                .stroke(Color.borderGray_Color, lineWidth: 1)
        )
        .padding([.vertical, .horizontal], 14)
    }
    
    /// 추천 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: productData.imageUrl) {
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
                return formatter.string(from: NSNumber(value: productData.price)) ?? "\(productData.price)"
            }
        
        
        VStack(alignment: .leading, spacing: 6) {
            Text(productData.name.split(separator: "").joined(separator: "\u{200B}"))
                .font(.suit(type: .semibold, size: 14))
                .foregroundStyle(Color.mainTextColor_Color)
                .lineLimit(nil)
                .lineSpacing(1.5)
            Text("\(formattedPrice)원")
                .font(.suit(type: .bold, size: 16))
                .foregroundStyle(Color.mainTextColor_Color)
        }
        .frame(maxWidth: 137)
    }
}


// MARK: - Preview

struct HomeRecommendProduct_Preview: PreviewProvider {
    static var previews: some View {
        HomeAIRecommendProduct(productData: AIRecommendProductResponseData(imageUrl: "https://image.sivillage.com/upload/C00001/goods/org/226/220831003041226.jpg?RS=750&SP=1", name: "아껴주다 저자극 천연 고양이 샴푸 500ml", price: 12000))
            .previewLayout(.sizeThatFits)
    }
}
