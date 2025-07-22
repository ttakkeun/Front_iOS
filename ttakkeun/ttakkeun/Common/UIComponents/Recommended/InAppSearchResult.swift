//
//  InAppSearchResult.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct InAppSearchResult: View {
    
    // MARK: - Property
    @Binding var data: ProductResponse
    let action: () -> Void
    
    // MARK: - Constants
    fileprivate enum InAppSearchResultConstant {
        static let mainVspacing: CGFloat = 10
        static let textLineSpacing: CGFloat = 1.5
        static let padding: CGFloat = 10
        
        static let textMinHegiht: CGFloat = 37
        static let cornerRadius: CGFloat = 10
        static let imageMaxCount: Int = 2
        static let imageTime: TimeInterval = 2
        static let imageSize: CGFloat = 160
        static let imagePlaceholder: String = "questionmark.square.fill"
    }
    
    // MARK: - Init
    init(data: Binding<ProductResponse>, action: @escaping () -> Void) {
        self._data = data
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: InAppSearchResultConstant.mainVspacing, content: {
            productImage
            productInfo
        })
    }
    
    /// 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    Image(systemName: InAppSearchResultConstant.imagePlaceholder)
                        .resizable()
                        .frame(width: InAppSearchResultConstant.imageSize, height: InAppSearchResultConstant.imageSize)
                }.retry(maxCount: InAppSearchResultConstant.imageMaxCount, interval: .seconds(InAppSearchResultConstant.imageTime))
                .resizable()
                .frame(width: InAppSearchResultConstant.imageSize, height: InAppSearchResultConstant.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: InAppSearchResultConstant.cornerRadius))
                .padding(InAppSearchResultConstant.padding)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: InAppSearchResultConstant.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200)
                })
        }
    }
    
    /// 상품 정보
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: InAppSearchResultConstant.mainVspacing, content: {
            Text(data.title.cleanedAndLineBroken())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(InAppSearchResultConstant.textLineSpacing)
                .frame(minHeight: InAppSearchResultConstant.textMinHegiht, alignment: .topLeading)
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            LikeButton(data: $data, action: action )
        })
    }
}

#Preview {
    InAppSearchResult(data: .constant(.init(productId: 1, title: "[디클펫] 7in1 진공 흡입 미용기 <b>강아지</b> 고양이 무선 바리깡 <b>애견</b> 클리퍼 트리머 브러쉬", image: "https://shopping-phinf.pstatic.net/main_8682898/86828986036.39.jpg", price: 1000, brand: "쿠팡", purchaseLink: "ㅋㅋㅋ", category1: "1", category2: "@", category3: "3", category4: "4", likeStatus: true)), action: {
        print("hello")
    })
}
