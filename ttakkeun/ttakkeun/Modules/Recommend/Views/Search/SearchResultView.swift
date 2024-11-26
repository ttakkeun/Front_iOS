//
//  SearchResultView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI

struct SearchResultView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    let padding: CGFloat = 25
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private var naverSearchResultGroup: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("외부 검색 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            naverSearchResult
        })
    }
    
    @ViewBuilder
    private var naverSearchResult: some View {
        if !viewModel.naverData.isEmpty {
            ScrollView(.horizontal, content: {
                HStack(spacing: 10, content: {
                    ForEach($viewModel.naverData, id: \.id) { data in
                        Text("hello")
                    }
                })
                .padding(.horizontal, padding)
            })
            
        } else {
            warningText(type: .naver)
        }
    }
    
    private var localSearchResultGroup: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            AIRecommendTitle(padding: padding, title: "앱 내 검색 결과")
        })
    }
    
//    private var localSearchResult: some View {
//        
//    }
}

extension SearchResultView {
    func warningText(type: SearchType) -> some View {
        Text(type.rawValue)
            .modifier(ProductWarningModifier())
    }
}
