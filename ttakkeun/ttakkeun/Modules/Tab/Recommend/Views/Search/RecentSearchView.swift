//
//  RecentSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI

/// 최근 검색 단어 보는 뷰
struct RecentSearchView: View {
    
    // MARK: - Property
    @Bindable var viewModel: SearchViewModel
    var onItemClick: (String) -> Void
    
    // MARK: - Constants
    fileprivate enum RecentSearchConstants {
        static let recentWordhVspacing: CGFloat = 14
        static let recentSearchVspacing: CGFloat = 20
        static let scrollHorizonPadding: CGFloat = 10
        static let recentHspacing: CGFloat = 10
        
        static let searchImageSize: CGFloat = 24
        static let deleteImageSize: CGFloat = 14
        static let lineSpacing: CGFloat = 2
        
        static let noRecentSearch: String = "최근 검색어 내역이 없습니다."
        static let recentSearch: String = "최근 검색"
        static let deleteSearchImage: String = "xmark"
    }
    
    // MARK: - Body
    var body: some View {
        if viewModel.recentSearches.isEmpty {
            notRecentSearches
        } else {
            recentSearch
        }
    }
  
    /// 최근 검색어 존재할 시
    private var recentSearch: some View {
        VStack(alignment: .leading, spacing: RecentSearchConstants.recentSearchVspacing, content: {
            Text(RecentSearchConstants.recentSearch)
            
            ScrollView(.vertical, content: {
                LazyVStack(alignment: .leading, spacing: RecentSearchConstants.recentSearchVspacing, content: {
                    ForEach(viewModel.recentSearches, id: \.self) { data in
                        makeSearchText(data)
                    }
                })
            })
            .contentMargins(.horizontal, RecentSearchConstants.scrollHorizonPadding)
        })
    }
    
    /// 최근 검색어 없을 시 등장
    private var notRecentSearches: some View {
        HStack {
            Spacer()
            Text(RecentSearchConstants.noRecentSearch)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func makeSearchText(_ text: String) -> some View {
        Button(action: {
            self.onItemClick(text)
        }, label: {
            recentSearchButton(text)
        })
    }
    
    /// 검색 버튼
    /// - Parameter text: 최근 검색어 내용
    /// - Returns: 검색어 버튼 반환
    private func recentSearchButton(_ text: String) -> some View {
        HStack(spacing: RecentSearchConstants.recentHspacing, content: {
            Image(.glass)
                .resizable()
                .frame(width: RecentSearchConstants.searchImageSize, height: RecentSearchConstants.searchImageSize)
            
            Text(text.cleanedAndLineBroken())
                .font(.Body2_regular)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .lineSpacing(RecentSearchConstants.lineSpacing)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: {
                viewModel.deleteSearch(text)
            }, label: {
                Image(systemName: RecentSearchConstants.deleteSearchImage)
                    .foregroundStyle(Color.gray500)
                    .frame(width: RecentSearchConstants.deleteImageSize, height: RecentSearchConstants.deleteImageSize)
            })
        })
    }
}

#Preview {
    RecentSearchView(viewModel: .init(container: DIContainer()), onItemClick: {
        print($0)
    })
}
