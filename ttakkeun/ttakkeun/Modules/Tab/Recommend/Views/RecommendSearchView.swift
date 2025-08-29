//
//  RecommendSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

/// 추천 아이템 검색 최근 검색어 내용
struct RecommendSearchView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: SearchViewModel
    @FocusState var isSearch: Bool
    
    // MARK: - Constant
    fileprivate enum RecommendSearchConstants {
        static let cornerRadius: CGFloat = 20
        static let deleteImageSize: CGFloat = 18
        static let textFieldPadding: CGFloat = 10
        static let dividerPadding: CGFloat = 20
        static let checvronImage: String = "chevron.backward"
        static let plceholder: String = "검색어를 입력하세요"
        static let naviTitle: String = "상품 검색"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if viewModel.isShowingSearchResult {
                SearchResultView(viewModel: viewModel)
            } else if viewModel.isShowingRealTimeResults {
                RealTiemSearchView(viewModel: viewModel, onItemClick: { selectedText in
                    performSearch(with: selectedText)
                })
            }  else {
                RecentSearchView(viewModel: viewModel, onItemClick: { selectedText in
                    performManualSearch(with: selectedText)
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .searchable(text: $viewModel.searchText, placement: .sidebar)
        .searchFocused($isSearch)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .customNavigation(title: RecommendSearchConstants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: RecommendSearchConstants.checvronImage))
        .task {
            self.isSearch.toggle()
        }
        .onChange(of: viewModel.searchText, { old, new in
            viewModel.handleSearchTextChange(old, new)
        })
    }
    
    // MARK: - TopContents
    
    /// 왼쪽 나가기 버튼
    private var leftChevronButton: some View {
        Button(action: {
            container.navigationRouter.pop()
        }, label: {
            Image(systemName: RecommendSearchConstants.checvronImage)
                .foregroundStyle(Color.black)
        })
    }
    
    private func performSearch(with text: String) {
        guard !text.isEmpty else { return }
        viewModel.fetchSearchResults(for: text)
        viewModel.isShowingSearchResult = true
        viewModel.saveSearchTerm(text)
    }
    
    private func performManualSearch(with text: String) {
        guard !text.isEmpty else { return }
        viewModel.isManualSearch = true
        viewModel.fetchSearchResults(for: text)
    }
}

#Preview {
    RecommendSearchView(container: DIContainer())
        .environmentObject(DIContainer())
}
