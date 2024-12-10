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
                .padding(.leading, 5)
            
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
                    .padding(.horizontal, 5)
                    .padding(.bottom, 12)
                })
                
            } else {
                warningText(type: .naver)
            }
        } else {
            loadingDataView(text: "외부 상품 정보를 가져오는 중입니다.")
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
        if !viewModel.isIitialLoading {
            if !viewModel.localDbData.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(162), spacing: 42), count: 2), spacing: 25, content: {
                    ForEach($viewModel.localDbData, id: \.self) { $data in
                        InAppSearchResult(data: $data)
                            .onAppear {
                                guard !viewModel.localDBDataIsLoading, viewModel.canLoadMore else { return }
                                
                                if data == viewModel.localDbData.last {
                                    print("🔵 마지막 항목 도달 - 다음 페이지 로딩 시작")
                                    viewModel.searchLocalDb(keyword: viewModel.searchText, page: viewModel.localPage)
                                }
                            }
                    }
                    
                    if viewModel.localDBDataIsLoading {
                        ProgressView()
                            .controlSize(.mini)
                    }
                })
            }
            else {
                warningText(type: .local)
            }
        } else {
            loadingDataView(text: "내부 상품 정보를 가져오는 중입니다.")
        }
    }
}

extension SearchResultView {
    func warningText(type: SearchType) -> some View {
        Text(type.rawValue)
            .modifier(ProductWarningModifier())
    }
    
    func loadingDataView(text: String) -> some View {
        HStack {
            Spacer()
            
            ProgressView(label: {
                Text(text)
            })
            .controlSize(.regular)
            
            Spacer()
        }
    }
}


struct SearchResultView_Preview: PreviewProvider {
    static var previews: some View {
        SearchResultView(viewModel: SearchViewModel(container: DIContainer()))
    }
}
