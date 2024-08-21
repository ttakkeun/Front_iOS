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
    
    let data: ProductDetailData
    let rank: Int
    // MARK: - Init
    
    init(
        data: ProductDetailData,
        rank: Int
    ) {
        self.data = data
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
        
        .frame(width: 84, height: 160)
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
        if let url = URL(string: data.image) {
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
            return formatter.string(from: NSNumber(value: data.price)) ?? "\(data.price)"
        }
        
        VStack(alignment: .leading, spacing: 4, content: {
            Text(stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .font(.suit(type: .medium, size: 10))
                .foregroundStyle(Color.gray_900)
                .lineLimit(nil)
                .lineSpacing(1.5)
            
            Text("\(formattedPrice)원")
                .font(.suit(type: .medium, size: 12))
                .foregroundStyle(Color.gray_900)
            
            Text(data.brand)
                .font(.suit(type: .regular, size: 8))
                .foregroundStyle(Color.gray_400)
        })
    }
    
    func stripHTMLTags(from htmlString: String) -> String {
        guard let data = htmlString.data(using: .utf8) else { return htmlString }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            
            return attributedString.string
        } catch {
            print("Failed to decode HTML entities: \(error)")
            return htmlString
        }
    }
}

//MARK: - Components

struct HomeUserRecommendProduct_Preview: PreviewProvider {
    static var previews: some View {
        HomeUserRecommendProduct(data: ProductDetailData(productId: 1, title: "아껴주다 저자극 천연 고양이 샴푸", image: "https://shopping-phinf.pstatic.net/main_8516432/85164327357.jpg", price: 12000, brand: "쿠팡", purchaseLink: "https://smartstore.naver.com/main/products/7619827035", category1: "건강", category2: "반려동물", category3: "관리용품", category4: "영양제", totalLike: 10, likeStatus: false), rank: 2)
            .previewLayout(.sizeThatFits)
    }
}
