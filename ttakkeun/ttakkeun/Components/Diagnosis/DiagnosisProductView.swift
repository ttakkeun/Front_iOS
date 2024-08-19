//
//  DiagnosisProductView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/19/24.
//

import SwiftUI
import Kingfisher

/// 일지 결과뷰에서 상품 조회 컴포넌트 뷰
struct DiagnosisProduct: View {
    
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
                            .frame(width: 100, height: 100)
                    }.retry(maxCount: 2, interval: .seconds(2))
                    .resizable()
                    .frame(width: 95, height: 95)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .stroke(Color.gray_200)
                    )
            }
            
            VStack(alignment: .leading, spacing: 5, content: {
                Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray_900)
                Text("\(data.lprice)원")
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray_900)
                
                Spacer()
                
                Text(data.brand)
                    .font(.Body5_medium)
                    .foregroundStyle(Color.gray_600)
            })
            .padding(.vertical, 10)
            .frame(height: 91)
        })
        .frame(width: 353, alignment: .leading)
    }
}

struct DiagnosisProductView_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosisProduct(data: AIProducts(title: "아껴주다", image: "ss", lprice: 12342, brand: "쿠팡"))
            .previewLayout(.sizeThatFits)
    }
}
