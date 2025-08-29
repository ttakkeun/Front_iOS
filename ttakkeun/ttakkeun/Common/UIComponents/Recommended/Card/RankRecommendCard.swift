//
//  RankRecommendation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI
import Kingfisher

/// 랭크별 추천 상품 카드
struct RankRecommendCard: View {
    
    // MARK: - Property
    @State var loadFailed: Bool = false
    @Binding var data: ProductResponse
    let rank: Int
    let action: () -> Void
    
    // MARK: - Constants
    fileprivate enum RankRecommendCardConstants {
        static let contentsHspacing: CGFloat = 12
        
        static let imageSize: CGFloat = 95
        static let productImageSize: CGFloat = 37
        static let loadingImageSize: CGFloat = 30
        
        static let lineLimit: Int = 2
        static let lineSpacing: Double = 1.5
        
        static let cornerRadius: CGFloat = 10
        static let imagePadding: CGFloat = 5
        static let imageTime: TimeInterval = 2
        static let imageMaxCount: Int =  2
        static let loadingImage: String = "questionmark.square.fill"
    }
    
    // MARK: - Init
    init(data: Binding<ProductResponse>, rank: Int, action: @escaping () ->  Void) {
        self._data = data
        self.rank = rank
        self.action = action
    }
    
    // MARK: Body
    var body: some View {
        HStack(spacing: RankRecommendCardConstants.contentsHspacing, content: {
            productImageGroup
            productInfo
        })
        .frame(maxWidth: .infinity)
        .frame(height: RankRecommendCardConstants.imageSize)
    }
    
    /// 상품 이미지 그룹
    private var productImageGroup: some View {
        ZStack(alignment: .bottomLeading, content: {
            productImage
            rankTag
        })
    }
    
    /// 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image), !loadFailed {
            KFImage(url)
                .placeholder {
                    notConnectUrlImaeg
                }.retry(maxCount: RankRecommendCardConstants.imageMaxCount, interval: .seconds(RankRecommendCardConstants.imageTime))
                .onFailure { _ in
                    loadFailed = true
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: RankRecommendCardConstants.imageSize, height: RankRecommendCardConstants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: RankRecommendCardConstants.cornerRadius))
                .padding(RankRecommendCardConstants.imagePadding)
                .overlay(
                    RoundedRectangle(cornerRadius: RankRecommendCardConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200)
                )
        } else {
            notConnectUrlImaeg
        }
    }
    
    private var notConnectUrlImaeg: some View {
        Image(systemName: RankRecommendCardConstants.loadingImage)
            .resizable()
            .frame(width: RankRecommendCardConstants.imageSize, height: RankRecommendCardConstants.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: RankRecommendCardConstants.cornerRadius))
            .padding(RankRecommendCardConstants.imagePadding)
            .overlay(
                RoundedRectangle(cornerRadius: RankRecommendCardConstants.cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200)
            )
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
    
    /// 상품 설명
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(data.title.removingHTMLTags())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(RankRecommendCardConstants.lineLimit)
                .multilineTextAlignment(.leading)
                .lineSpacing(RankRecommendCardConstants.lineSpacing)
                .frame(height: RankRecommendCardConstants.productImageSize, alignment: .topLeading)
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            Spacer()
            
            LikeButton(data: $data, action: action)
        })
        .frame(height: RankRecommendCardConstants.imageSize, alignment: .leading)
    }
}

#Preview {
    RankRecommendCard(data: .constant(
        .init(productId: 0, title: "잘먹잘싸 <b>강아지</b>사료 기호성좋은 연어, 2kg, 1<b>개</b>", image: "s", price: 1000, brand: "쿠핑", purchaseLink: "쿠핑", category1: "쿠핑", category2: "쿠핑", category3: "쿠핑", category4: "쿠핑", likeStatus: true)
    ), rank: 2, action: {
        print("hello")
    })
}
