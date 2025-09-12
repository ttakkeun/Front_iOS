//
//  RecentRecommendation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI
import Kingfisher

/// 물품 검색 카드
struct RecentRecommendCard: View {
    
    // MARK: - Property
    @Binding var data: ProductResponse
    let type: ProductLocation
    let action: () -> Void
    
    // MARK: - Constants
    fileprivate enum RecentRecommendConstants {
        static let contentsHspacing: CGFloat = 14
        static let imagePadding: CGFloat = 5
        static let productInfoVspacing: CGFloat = 6
        static let titleHeight: CGFloat = 37
        static let contentsHeight: CGFloat = 64
        
        static let cornerRadius: CGFloat = 10
        static let imageMaxCount: Int = 2
        static let imageTime: TimeInterval = 2
        static let lineSpacing: CGFloat = 1.5
    }
    
    // MARK: - Init
    init(data: Binding<ProductResponse>, type: ProductLocation, action: @escaping () -> Void) {
        self._data = data
        self.type = type
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: RecentRecommendConstants.contentsHspacing, content: {
            productImage
            productInfo
        })
        .padding(.top, type.backgroundPadding.0)
        .padding(.bottom, type.backgroundPadding.1)
        .padding(.leading, type.backgroundPadding.2)
        .padding(.trailing, type.backgroundPadding.3)
        .background {
            RoundedRectangle(cornerRadius: RecentRecommendConstants.cornerRadius)
                .fill(type.backgroundColor)
                .shadow05()
        }
    }
    
    /// 상품 정보
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: RecentRecommendConstants.productInfoVspacing, content: {
            Text(data.title.removingHTMLTags())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .lineSpacing(RecentRecommendConstants.lineSpacing)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
            
            Spacer()
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            if type == .naver {
                likeIcon
            }
        })
    }
    
    /// 최근 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: RecentRecommendConstants.imageMaxCount, interval: .seconds(RecentRecommendConstants.imageTime))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: type.productSize.0, height: type.productSize.1)
                .clipShape(RoundedRectangle(cornerRadius: RecentRecommendConstants.cornerRadius))
        }
    }
    
    /// 좋아요 버튼
    private var likeIcon: some View {
        HStack {
            Spacer()
            LikeButton(data: $data, action: action)
        }
    }
}

#Preview {
    @Previewable @State var data: ProductResponse = .init(productId: 2, title: "트리스 이디티에이 120ml, 1개", image: "https://shopping-phinf.pstatic.net/main_5192947/51929474258.20241213220325.jpg", price: 12000, brand: "쿠팡", purchaseLink: "111", category1: "11", category2: "!1", category3: "11", category4: "11", likeStatus: true)
    RecentRecommendCard(data: $data, type: .naver, action: {
        print("1")
    })
}
