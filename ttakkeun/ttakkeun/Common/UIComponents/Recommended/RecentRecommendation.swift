//
//  RecentRecommendation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI
import Kingfisher

struct RecentRecommendation: View {
    
    @Binding var data: ProductResponse
    let type: ProductLocation
    
    init(data: Binding<ProductResponse>, type: ProductLocation) {
        self._data = data
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 14, content: {
            productImage
            
            productInfo
        })
        .frame(width: returnBackgroundSize().0, height: returnBackgroundSize().1, alignment: .topLeading)
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor())
                .shadow05()
        }
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
                .frame(height: 37, alignment: .topLeading)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.5)
                .truncationMode(.tail)
            
            Text("\(DataFormatter.shared.formattedPrice(from: data.price))원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            likeIcon
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
                .frame(width: returnProductSize().0, height: returnProductSize().1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(5)
        }
    }
    
    @ViewBuilder
    private var likeIcon: some View {
        if type == .naver {
            Spacer()
            
            LikeButton(data: $data)
        } else {
        }
    }
    
}

extension RecentRecommendation {
    func backgroundColor() -> Color {
        switch type {
        case .naver:
            return Color.searchBg
        case .localDB:
            return Color.primarycolor400
        }
    }
    
    func returnProductSize() -> (CGFloat, CGFloat) {
        switch type {
        case .naver:
            return (95, 95)
        case .localDB:
            return (64, 64)
        }
    }
    
    func returnBackgroundSize() -> (CGFloat, CGFloat) {
        switch type {
        case .naver:
            return (343, 95)
        case .localDB:
            return (213, 64)
        }
    }
}

struct RecentRecommendation_Preview: PreviewProvider {
    
    @State static var data = ProductResponse(productId: 1, title: "아모스 녹차실감 산뜻한 타입 지성 모발용 <b>샴푸</b> 500g", image: "https://shopping-phinf.pstatic.net/main_2099178/20991784508.20191001111748.jpg", price: 8780, brand: "아모스", purchaseLink: "https://search.shopping.naver.com/catalog/20991784508", category1: "화장품/미용", category2: "헤어케어", category3: "샴푸", category4: "", totalLike: 9, likeStatus: false)
    
    static var previews: some View {
        RecentRecommendation(data: $data, type: .naver)
    }
}
