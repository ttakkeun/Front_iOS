//
//  NaverSearchProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import SwiftUI
import Kingfisher

struct NaverSearchProduct: View {
    
    @Binding var data: ProductResponse
    
    init(data: Binding<ProductResponse>) {
        self._data = data
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private var searchImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }
        }
    }
}
