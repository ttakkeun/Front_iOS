//
//  RecommendSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

struct RecommendSearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            topControl
            RecentSearchView(viewModel: viewModel)
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 21, bottom: 0, trailing: 21))
    }
    
    private var topControl: some View {
        HStack(spacing: 24, content: {
            Button(action: {
                viewModel.isSearchActive = false
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.black)
            })
            
            CustomTextField(text: $viewModel.searchText, placeholder: "검색어를 입력하세요.", cornerRadius: 20, padding: 23, maxWidth: 319, maxHeight: 40)
        })
    }
}

struct RecommendSearchView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendSearchView(viewModel: SearchViewModel())
    }
}
