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
        VStack(alignment: .leading, spacing: 5, content: {
            topControl
            
            Divider()
                .padding(.top, 3)
                .foregroundStyle(Color.gray300)
            
            Spacer()
            
            RealTiemSearchView(viewModel: viewModel)
        })
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
        .modifier(SearchViewModifier())
    }
}

struct RecommendSearchView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendSearchView(viewModel: SearchViewModel())
    }
}
