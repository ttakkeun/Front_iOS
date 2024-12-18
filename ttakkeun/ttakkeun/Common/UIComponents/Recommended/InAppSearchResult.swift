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
    let action: () -> Void
    let size: CGFloat = 160
    
    init(data: Binding<ProductResponse>, action: @escaping () -> Void) {
        self._data = data
        self.action = action
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
                    Image(systemName: "questionmark.square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
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
            Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.5)
                .frame(height: 37, alignment: .topLeading)
            
            Text("\(data.price)원")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            LikeButton(data: $data, action: action )
        })
        .frame(width: size)
    }
}
