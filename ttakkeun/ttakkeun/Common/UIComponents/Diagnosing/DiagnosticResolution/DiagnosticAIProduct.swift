//
//  DiagnosticProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import SwiftUI
import Kingfisher

/// 진단 결과 시, AI의 상품 조회 카드
struct DiagnosticAIProduct: View {
    
    let data: AIProducts
    
    init(data: AIProducts) {
        self.data = data
    }
    
    var body: some View {
        HStack(spacing: 12, content: {
            if let url = URL(string: data.image) {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                            .controlSize(.regular)
                    }.retry(maxCount: 2, interval: .seconds(2))
                    .resizable()
                    .frame(width: 95, height: 95)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .stroke(Color.gray200)
                    )
            }
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(data.title)
                        .font(.Body3_semibold)
                        .foregroundStyle(Color.gray900)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(1.5)
                        .frame(height: 37, alignment: .topLeading)
                    
                    Text("\(data.lprice)원")
                        .font(.Body2_semibold)
                        .foregroundStyle(Color.gray900)
                    
                    Text(data.brand)
                        .font(.Body5_medium)
                        .foregroundStyle(Color.gray600)
                })
        })
        .frame(width: 353, height: 95, alignment: .leading)
    }
}


struct DiagnosticAIProfile_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosticAIProduct(data: AIProducts(title: "꾸까라라라어쩌구저라꾸까라라라어쩌aldlakaldlk구저라", image: "https://i.namu.wiki/i/fCX1vEyfl7n8sCOlr7u8Y0poz53uK-6-dxprHjpmkvC7rJnwfmliLqjcz1ryRdVJq7CJGsxfDlxmS4Nn6v0gl2Ouds1cumIID343BMFwQspWsrc9VsedYgOe-OMKvRawpCQmonLljjSpjm2RWLAwnw.webp", lprice: 13000, brand: "쿠팡"))
    }
}
