//
//  RealTiemSearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI
import Kingfisher

/// 실시간 검색 화면
struct RealTiemSearchView: View {
    
    // MARK: - Property
    @Bindable var viewModel: SearchViewModel
    var onItemClick: (String) -> Void
    
    // MARK: - Constants
    fileprivate enum RealTiemSearchConstants {
        static let searchProductHspacing: CGFloat = 14
        static let searchNoProductHspacing: CGFloat = 10
        static let productInfoVspacing: CGFloat = 4
        static let productVspacing: CGFloat = 15
        static let listRowSpacing: CGFloat = 15
        
        static let searchResultImageSize: CGFloat = 48
        static let noResultImageSize: CGFloat = 35
        
        
        static let imageMaxCount: Int = 2
        static let imagTimeInterval: TimeInterval = 2
        static let lineSpacing: CGFloat = 2
        
        static let noRealTimeSearchImge: String = "magnifyingglass.circle"
    }
    
    // MARK: - Body
    var body: some View {
        if !viewModel.realTimeSearchResult.isEmpty {
            searchResult
        } else {
            notRealtTimeSearchResult
        }
    }
    
    private var searchResult: some View {
        ScrollView(.vertical, content: {
            LazyVStack(alignment: .leading, spacing: RealTiemSearchConstants.listRowSpacing, content: {
                ForEach(viewModel.realTimeSearchResult, id: \.id) { data in
                    makeSearchingResultButton(data: data)
                }
            })
        })
    }
    
    /// 검색 데이터 존재하지 않을 시
    @ViewBuilder
    private var notRealtTimeSearchResult: some View {
        if viewModel.searchText.count > .zero {
            VStack {
                HStack(spacing: RealTiemSearchConstants.searchNoProductHspacing, content: {
                    Image(systemName: RealTiemSearchConstants.noRealTimeSearchImge)
                        .resizable()
                        .frame(width: RealTiemSearchConstants.noResultImageSize, height: RealTiemSearchConstants.noResultImageSize)
                    Text(viewModel.searchText)
                        .font(.Body3_bold)
                        .foregroundStyle(Color.gray900)
                    Spacer()
                })
                
                Spacer()
            }
        }
    }
    
    /// 검색 결과 버튼
    /// - Parameter data: 검색 데이터
    /// - Returns: 검색 결과
    func makeSearchingResultButton(data: ProductResponse) -> some View {
        Button(action: {
            viewModel.saveSearchTerm(data.title)
            self.onItemClick(data.title)
        }, label: {
            HStack(spacing: RealTiemSearchConstants.searchProductHspacing, content: {
                makeSearchingImage(image: data.image)
                makeProductInfo(infoText: (data.title, data.price))
            })
        })
    }
    
    /// 검색 결과 이미지
    /// - Parameter image: 이미지 url
    /// - Returns: 이미지 반환
    @ViewBuilder
    func makeSearchingImage(image: String) -> some View {
        if let url = URL(string: image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: RealTiemSearchConstants.imageMaxCount, interval: .seconds(RealTiemSearchConstants.imagTimeInterval))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: RealTiemSearchConstants.searchResultImageSize, height: RealTiemSearchConstants.searchResultImageSize)
        }
    }
    
    /// 검색 결과 상품 정보
    /// - Parameter infoText: 검색 결과 상품 이름 및 가격
    /// - Returns: 상품 정보 반환
    func makeProductInfo(infoText: (String, Int)) -> some View {
        VStack(alignment: .leading, spacing: RealTiemSearchConstants.productInfoVspacing, content: {
            Text((infoText.0).cleanedAndLineBroken())
                .font(.Body3_regular)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(RealTiemSearchConstants.lineSpacing)
                .foregroundStyle(Color.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(infoText.1)원")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray500)
        })
    }
}

#Preview {
    RealTiemSearchView(viewModel: .init(container: DIContainer()), onItemClick: {
        print($0)
    })
}
