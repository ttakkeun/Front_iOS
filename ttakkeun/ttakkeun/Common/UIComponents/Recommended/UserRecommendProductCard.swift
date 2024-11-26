//
//  UserRecommendProductCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI
import Kingfisher

struct UserRecommendProductCard: View {
    
    let data: ProductResponse
    let rank: Int
    
    init(_ data: ProductResponse,
         _ rank: Int
    ) {
        self.data = data
        self.rank = rank
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            ZStack(alignment: .bottomLeading, content: {
                productImage
                rankTag
            })
            .shadow03()
            
            productInfo
        })
        .frame(width: 84, height: 160)
    }
    
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
                .font(.Detail1_bold)
                .foregroundStyle(Color.white)
        }
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
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
    
    @ViewBuilder
    private var productInfo: VStack<some View> {
        VStack(alignment: .leading, spacing: 4, content: {
            Text(DataFormatter.shared.stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body5_medium)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .lineSpacing(1.5)
            
            VStack(alignment: .leading, spacing: 0, content: {
                
                Text("\(DataFormatter.shared.formattedPrice(from: data.price))원")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
                
                Text(data.brand)
                    .font(.Detail2_regular)
                    .foregroundStyle(Color.gray400)
            })
        })
    }
}

struct UserRecommendProductCard_Preview: PreviewProvider {
    static var previews: some View {
        UserRecommendProductCard(ProductResponse(productId: 1, title: "아껴주다 저자극 천연 고양이 샴푸", image: "https://shopping-phinf.pstatic.net/main_8516432/85164327357.jpg", price: 12000, brand: "쿠팡", purchaseLink: "https://smartstore.naver.com/main/products/7619827035", category1: "건강", category2: "반려동물", category3: "관리용품", category4: "영양제", totalLike: 10, likeStatus: false), 2)
            .previewLayout(.sizeThatFits)
    }
}
