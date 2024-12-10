//
//  SearchResultView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI

struct SearchResultView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    let padding: CGFloat = 20
    
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: 27, content: {
                naverSearchResultGroup
                
                localSearchResultGroup
            })
            .modifier(SearchViewModifier())
        })
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
        if !viewModel.naverDataIsLoading {
            if !viewModel.naverData.isEmpty {
                ScrollView(.horizontal, content: {
                    HStack(spacing: 10, content: {
                        ForEach($viewModel.naverData, id: \.id) { $data in
                            RecentRecommendation(data: $data, type: .naver)
                        }
                    })
                    .padding(.horizontal, 10)
                    .padding(.bottom, 12)
                })
                
            } else {
                warningText(type: .naver)
            }
        } else {
            HStack {
                
                Spacer()
                
                ProgressView(label: {
                    Text("외부 상품 정보를 가져오는 중입니다.")
                })
                    .controlSize(.small)
                
                Spacer()
            }
        }
    }
    
    private var localSearchResultGroup: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            AIRecommendTitle(padding: 5, title: "앱 내 검색 결과")
            
            localSearchResult
        })
    }
    
    @ViewBuilder
    private var localSearchResult: some View {
        if !viewModel.localDbData.isEmpty {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(162)), count: 2), spacing: 10 , content: {
                ForEach($viewModel.localDbData, id: \.self) { $data in
                    InAppSearchResult(data: $data)
                }
            })
        } else {
            warningText(type: .local)
        }
    }
}

extension SearchResultView {
    func warningText(type: SearchType) -> some View {
        Text(type.rawValue)
            .modifier(ProductWarningModifier())
    }
}


struct SearchResultView_Preview: PreviewProvider {
    static var previews: some View {
        SearchResultView(viewModel: SearchViewModel(container: DIContainer()))
    }
}
