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
    
    // MARK: - Property
    let data: AIProducts
    
    // MARK: - Constants
    fileprivate enum DiagnosticConstants {
        static let mainHspacing: CGFloat = 12
        static let textVspacing: CGFloat = 10
        
        static let imageSize: CGFloat = 95
        static let textHeight: CGFloat = 37
        
        static let lineSpacing: Double = 1.5
        static let maxCount: Int = 2
        static let lineLimit: Int = 2
        static let second: TimeInterval = 2
        static let cornerRadius: CGFloat = 10
        
        static let emptyBrandText: String = "정보 없음"
    }
    
    // MARK: - Init
    init(data: AIProducts) {
        self.data = data
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: DiagnosticConstants.mainHspacing, content: {
            productImage
            rightProductInfo
        })
    }
    
    private var rightProductInfo: some View {
        VStack(alignment: .leading, spacing: DiagnosticConstants.textVspacing, content: {
            Text(data.title)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(DiagnosticConstants.lineLimit)
                .multilineTextAlignment(.leading)
                .lineSpacing(DiagnosticConstants.lineSpacing)
                .frame(height: DiagnosticConstants.textHeight, alignment: .topLeading)
            
            Text("\(data.lprice)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            Text(data.brand.isEmpty ? DiagnosticConstants.emptyBrandText : data.brand)
                .font(.Body5_medium)
                .foregroundStyle(Color.gray600)
        })
    }
    /// 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: DiagnosticConstants.maxCount, interval: .seconds(DiagnosticConstants.second))
                .resizable()
                .frame(width: DiagnosticConstants.imageSize, height: DiagnosticConstants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: DiagnosticConstants.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: DiagnosticConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200)
                )
        }
    }
}


struct DiagnosticAIProfile_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosticAIProduct(data: AIProducts(title: "꾸까라라라어쩌구저라꾸까라라라어쩌aldlakaldlk구저라", image: "https://i.namu.wiki/i/fCX1vEyfl7n8sCOlr7u8Y0poz53uK-6-dxprHjpmkvC7rJnwfmliLqjcz1ryRdVJq7CJGsxfDlxmS4Nn6v0gl2Ouds1cumIID343BMFwQspWsrc9VsedYgOe-OMKvRawpCQmonLljjSpjm2RWLAwnw.webp", lprice: 13000, brand: "쿠팡"))
            .previewLayout(.sizeThatFits)
    }
}

