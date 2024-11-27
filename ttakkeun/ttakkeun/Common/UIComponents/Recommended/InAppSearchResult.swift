//
//  InAppSearchResult.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct InAppSearchResult: View {
    
    @Binding var data: ProductResponse
    let size: CGFloat = 162
    
    init(data: Binding<ProductResponse>) {
        self._data = data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            productImage
            productInfo
        })
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(10)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray200)
                })
        }
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(DataFormatter.shared.stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.5)
                .frame(height: 37, alignment: .topLeading)
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            LikeButton(data: $data)
        })
        .frame(width: size)
    }
}

struct InAppSearchResult_Preview: PreviewProvider {
    static var previews: some View {
        InAppSearchResult(data: .constant(ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 9, likeStatus: false)))
    }
}
