//
//  RecentSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI

struct RecentSearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 12, content: {
            recentSearches
        })
    }
    
    @ViewBuilder
    private var recentSearches: some View {
        if viewModel.recentSearches.isEmpty {
            
            Spacer()
            notRecentSearches
            
            Spacer()
        } else {
            Text("최근 검색")
                .font(.Body3_bold)
                .foregroundStyle(Color.gray900)
            
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, spacing: 12, content: {
                    ForEach(viewModel.recentSearches, id: \.self) { data in
                        makeSearchText(data)
                    }
                    .padding(.leading, 10)
                })
            })
        }
    }
    
    private var notRecentSearches: HStack<some View> {
        HStack {
            
            Spacer()
            
            Text("최근 검색어 내역이 없습니다.")
                .font(.Body2_medium)
                .foregroundStyle(Color.gray900)
            
            Spacer()
        }
    }
}

extension RecentSearchView {
    func makeSearchText(_ text: String) -> some View {
        Button(action: {
            viewModel.searchText = text
        }, label: {
            HStack(spacing: 10, content: {
                Icon.glass.image
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(text)
                    .font(.Body2_regular)
                    .foregroundStyle(Color.gray900)
                
                Spacer()
                
                
                Button(action: {
                    viewModel.deleteSearch(text)
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.gray500)
                        .frame(width: 14, height: 14)
                })
            })
        })
    }
}

struct RecentSearchView_Preview: PreviewProvider {
    static var previews: some View {
        RecentSearchView(viewModel: SearchViewModel())
    }
}

