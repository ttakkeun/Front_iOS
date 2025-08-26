//
//  UserRecommendProductCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI
import Kingfisher

/// 추천 제품 Top8
struct UserRecommendProductCard: View {
    
    // MARK: - Property
    let data: ProductResponse
    let rank: Int
    
    // MARK: - Property
    fileprivate enum UserRecommendProductConstants {
        static let productVspacing: CGFloat = 4
        
        static let imageMaxCount: Int = 2
        static let imageInterval: TimeInterval = 2
        
        static let imageWidth: CGFloat = 84
        static let imageHeight: CGFloat = 98
        
        static let lineLimit: Int = 2
        static let lineSpacing: CGFloat = 1.5
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Init
    init(_ data: ProductResponse,
         _ rank: Int
    ) {
        self.data = data
        self.rank = rank
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: UserRecommendProductConstants.productVspacing, content: {
            topContents
            productInfo
        })
    }
    
    // MARK: - TopContents
    private var topContents: some View {
        ZStack(alignment: .bottomLeading, content: {
            productImage
            rankTag
        })
        .shadow03()
    }
    /// 랭크 태그
    @ViewBuilder
    private var rankTag: some View {
        ZStack {
            if (0...2).contains(rank) {
                Image(.topRank)
                    .fixedSize()
            } else {
                Image(.bottomRank)
                    .fixedSize()
            }
            Text("\(rank + 1)")
                .font(.Detail1_bold)
                .foregroundStyle(Color.white)
        }
    }
    
    /// 제품 상품
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: UserRecommendProductConstants.imageMaxCount, interval: .seconds(UserRecommendProductConstants.imageInterval))
                .onFailure { _ in
                    print("반료동물 추천 제품 이미지 로딩 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: UserRecommendProductConstants.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: UserRecommendProductConstants.cornerRadius))
        }
    }
    
    // MARK: - BottomContents
    /// 제품 정보
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: UserRecommendProductConstants.productVspacing, content: {
            productDiscrip
            priceCompany
        })
        .frame(maxWidth: .infinity)
    }
    
    private var productDiscrip: some View {
        Text(data.title)
            .font(.Body5_medium)
            .foregroundStyle(Color.gray900)
            .lineLimit(UserRecommendProductConstants.lineLimit)
            .lineSpacing(UserRecommendProductConstants.lineSpacing)
    }
    
    private var priceCompany: some View {
        VStack(alignment: .leading, spacing: .zero, content: {
            Text("\(data.price)원")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
            
            if let brand = data.brand {
                Text(brand)
                    .font(.Detail2_regular)
                    .foregroundStyle(Color.gray400)
            }
        })
    }
}

struct UserRecommendProductCard_Preview: PreviewProvider {
    static var previews: some View {
        UserRecommendProductCard(ProductResponse(productId: 1, title: "아껴주다 저자극 천연 고양이 샴푸", image: "https://shopping-phinf.pstatic.net/main_8516432/85164327357.jpg", price: 12000, brand: "쿠팡", purchaseLink: "https://smartstore.naver.com/main/products/7619827035", category1: "건강", category2: "반려동물", category3: "관리용품", category4: "영양제", totalLike: 10, likeStatus: false), 2)
            .previewLayout(.sizeThatFits)
    }
}
