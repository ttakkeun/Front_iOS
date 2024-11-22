//
//  RecentRecommendation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI
import Kingfisher

struct RecentRecommendation: View {
    
    let data: ProductResponse
    
    init(data: ProductResponse) {
        self.data = data
    }
    
    var body: some View {
        HStack(spacing: 14, content: {
            productImage
            
            productInfo
        })
        .frame(width: 213, height: 64)
        .padding(.top, 21)
        .padding(.leading, 19)
        .padding([.trailing, .bottom], 23)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.primarycolor400)
                .shadow05()
        }
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(DataFormatter.shared.stripHTMLTags(from: data.title).split(separator: "").joined(separator: "\u{200B}"))
                .frame(height: 37)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.5)
            
            Text("\(DataFormatter.shared.formattedPrice(from: data.price))원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
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
                .aspectRatio(contentMode: .fill)
                .frame(width: 62, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
}

struct RecentRecommendation_Preview: PreviewProvider {
    static var previews: some View {
        RecentRecommendation(data: ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: nil, likeStatus: false))
    }
}
