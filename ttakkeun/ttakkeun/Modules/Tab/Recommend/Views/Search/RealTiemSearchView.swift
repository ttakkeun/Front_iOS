//
//  RealTiemSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI
import Kingfisher

struct RealTiemSearchView: View {
    
    @Bindable var viewModel: SearchViewModel
    var onItemClick: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            if let data = viewModel.realTimeSearchResult {
                if data != [] {
                    ForEach(data, id: \.self) { data in
                        makeSearchingResultButton(data: data)
                    }
                }
            } else {
                notRealtTimeSearchResult
            }
            
            Spacer()
        })
        .frame(maxWidth: .infinity)
        .modifier(SearchViewModifier())
    }
    
    @ViewBuilder
    private var notRealtTimeSearchResult: some View {
        if viewModel.searchText.count > 0 {
            HStack(spacing: 10, content: {
                Image(systemName: "magnifyingglass.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
                
                Text(viewModel.searchText)
                    .font(.Body3_bold)
                    .foregroundStyle(Color.gray900)
                
                Spacer()
            })
        }
    }
}

extension RealTiemSearchView {
    func makeSearchingResultButton(data: ProductResponse) -> some View {
        Button(action: {
            viewModel.saveSearchTerm(data.title)
            self.onItemClick(data.title)
        }, label: {
            HStack(spacing: 14, content: {
                makeSearchingImage(image: data.image)
                
                makeProductInfo(infoText: (data.title, data.price))
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
    
    @ViewBuilder
    func makeSearchingImage(image: String) -> some View {
        if let url = URL(string: image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
        }
    }
    
    func makeProductInfo(infoText: (String, Int)) -> some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Text((infoText.0).split(separator: "").joined(separator: "\u{200B}"))
                .font(.Body3_regular)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .foregroundStyle(Color.gray900)
            
            Text("\(DataFormatter.shared.formattedPrice(from: infoText.1))원")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray500)
        })
    }
}
