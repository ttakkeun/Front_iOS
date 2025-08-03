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
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
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
        .safeAreaPadding(.top, UIConstants.defaultSafeTop)
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                leftChevronButton
            })
            
            ToolbarItem(placement: .principal, content: {
                searchBar
            })
        })
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
    
    /// 검색바
    private var searchBar: some View {
        HStack {
            TextField("", text: $viewModel.searchText)
                .focused($isSearch)
                .submitLabel(.search)
                .onSubmit {
                    performSearch(with: viewModel.searchText)
                }
            
            Button(role: .destructive, action: {
                viewModel.searchText.removeAll()
            }, label: {
                Image(.deleteText)
                    .resizable()
                    .frame(width: RecommendSearchConstants.deleteImageSize, height: RecommendSearchConstants.deleteImageSize)
            })
        }
        .frame(maxWidth: .infinity)
        .padding(RecommendSearchConstants.textFieldPadding)
        .background {
            RoundedRectangle(cornerRadius: RecommendSearchConstants.cornerRadius)
                .fill(Color.white)
                .stroke(Color.gray200, style: .init())
        }
        .submitScope()
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
