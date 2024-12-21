//
//  RecommendSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

struct RecommendSearchView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: SearchViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            topControl
            
            Divider()
                .padding(.top, 5)
                .foregroundStyle(Color.gray200)
            
            Spacer()
            
            ScrollView(.vertical) {
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
        })
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
    }
    
    
    private var topControl: some View {
        HStack(spacing: 24, content: {
            Button(action: {
                container.navigationRouter.pop()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.black)
            })
            
            CustomTextField(text: $viewModel.searchText, placeholder: "검색어를 입력하세요.", cornerRadius: 20, padding: 23, maxWidth: 319, maxHeight: 40, onSubmit: {
                performSearch(with: viewModel.searchText)
            })
            .onChange(of: viewModel.searchText) { newValue, oldValue in
                viewModel.handleSearchTextChange(newValue, oldValue)
            }
            .submitScope()
        })
        .modifier(SearchViewModifier())
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
