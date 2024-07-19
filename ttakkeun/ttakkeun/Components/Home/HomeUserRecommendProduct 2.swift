//
//  HomeUserRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import SwiftUI
import Kingfisher

/// 유저 추천 제품 Top8
struct HomeUserRecommendProduct: View {
    
    let productData: UserRecommendProductResponseData
    let rank: Int
    
    // MARK: - Init
    
    init(
        productData: UserRecommendProductResponseData,
        rank: Int
    ) {
        self.productData = productData
        self.rank = rank
    }
    
    // MARK: - Components
    
    var body: some View {
        contents
    }
    
    private var contents: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            ZStack(alignment: .bottomLeading, content: {
                productImage
                rankTag
            })
            .shadow03()
            
            productInfo
        })
        .frame(maxWidth: 84, maxHeight: 160)
    }
    
    /// 순위 표시 태그
    @ViewBuilder
    private var rankTag: some View {
        ZStack {
            if (0...2).contains(rank) {
                Icon.topRank.image
                    .fixedSize()
            } else {
                Icon.bottomRank.image
                    .fixedSize()
            }
            Text("\(rank + 1)")
                .font(.suit(type: .bold, size: 10))
                .foregroundStyle(Color.white)
        }
    }
    
    
    /// 반려동물 추천 제품 Top8 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: productData.productImage) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("반료동물 추천 제품 이미지 로당 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 84, maxHeight: 98)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    /// 추천 제품 상세 Info
    @ViewBuilder
    private var productInfo: some View {
        
        var formattedPrice: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: productData.productPrice)) ?? "\(productData.productPrice)"
        }
        
        VStack(alignment: .leading, spacing: 4, content: {
            Text(productData.productTitle.split(separator: "").joined(separator: "\u{200B}"))
                .font(.suit(type: .medium, size: 10))
                .foregroundStyle(Color.mainTextColor_Color)
                .lineLimit(nil)
                .lineSpacing(1.5)
            
            Text("\(formattedPrice)원")
                .font(.suit(type: .medium, size: 12))
                .foregroundStyle(Color.mainTextColor_Color)
            
            Text(productData.productCompany)
                .font(.suit(type: .regular, size: 8))
                .foregroundStyle(Color.subTextColor_Color)
        })
        
    }
}

//MARK: - Components

struct HomeUserRecommendProduct_Preview: PreviewProvider {
    static var previews: some View {
        HomeUserRecommendProduct(productData: UserRecommendProductResponseData(productImage: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg", productTitle: "아껴주다 저자극 천연 고양이 샴푸", productPrice: 18000, productCompany: "쿠팡"), rank: 0)
    }
}
