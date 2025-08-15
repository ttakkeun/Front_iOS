//
//  SearchResultView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import SwiftUI

struct SearchResultView: View {
    
    // MARK: - Property
    @Bindable var viewModel: SearchViewModel
    
    // MARK: Constants
    fileprivate enum SearchResultConstants {
        static let gridSpacing: CGFloat = 8
        static let contentsVspacing: CGFloat = 27
        static let listSpacing: CGFloat = 10
        static let lineSpacing: CGFloat = 2
        static let itemHspacing: CGFloat = 42
        static let itemVspacing: CGFloat = 25
        
        static let listHeight: CGFloat = 400
        
        static let itemColumCount: Int = 2
        static let screenHeight: CGFloat = 540
        
        static let naverTitle: String = "외부 검색 상품"
        static let localTitle: String = "앱 내 검색 결과"
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: SearchResultConstants.contentsVspacing, content: {
                naverSearchResultSection
                localSearchResultSection
            })
        })
        .sheet(item: $viewModel.selectedData, onDismiss: {
            viewModel.selectedData = nil
        }, content: { data in
            ProductSheetView(data: sheetBinding(data: data), action: {
                viewModel.likeProduct(productId: data.productId, productData: viewModel.makeLikePatchRequest(data: data))
            })
            .presentationDetents([.height(SearchResultConstants.screenHeight)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(UIConstants.sheetCornerRadius)
        })
    }
    
    // MARK: - Naver
    /// 네이버 검색 섹션
    private var naverSearchResultSection: some View {
        Section(content: {
            naverSearchResult
        }, header: {
            groupBoxTitle(SearchResultConstants.naverTitle)
        })
    }
    
    /// 네이버 검색 상품 결과
    @ViewBuilder
    private var naverSearchResult: some View {
        if !viewModel.naverDataIsLoading {
            naverNotLoadingResult
        } else {
            loadingDataView(type: .naver)
        }
    }
    
    /// 네이버 상품 조회 로딩 아닐 시
    @ViewBuilder
    private var naverNotLoadingResult: some View {
        if !viewModel.naverData.isEmpty {
            ScrollView(.vertical, content: {
                LazyVStack(spacing: SearchResultConstants.listSpacing, content: {
                    ForEach($viewModel.naverData, id: \.id) { $data in
                        RecentRecommendCard(
                            data: $data,
                            type: .naver,
                            action: { viewModel.likeProduct(
                                productId: data.productId,
                                productData: viewModel.makeLikePatchRequest(data: data))
                            })
                        .handleTapGesture(with: viewModel, data: data, source: .searchNaverProduct)
                    }
                })
            })
            .contentMargins(.bottom, 10, for: .scrollContent)
            .frame(height: SearchResultConstants.listHeight)
            .scrollIndicators(.hidden)
        } else {
            warningText(type: .naver)
        }
    }
    
    
    // MARK: - Local
    /// 앱 내 검색 섹션
    private var localSearchResultSection: some View {
        VStack(alignment: .leading, spacing: .zero, content: {
            AIRecommendTitle(title: SearchResultConstants.localTitle)
            localSearchResult
        })
    }
    
    /// 앱 내 검색 결과
    @ViewBuilder
    private var localSearchResult: some View {
        if !viewModel.localDBDataIsLoading {
            localNotLoadingResult
        } else {
            loadingDataView(type: .local)
        }
    }
    
    /// 앱 내 검색 결과 비로딩시
    @ViewBuilder
    private var localNotLoadingResult: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: SearchResultConstants.gridSpacing), count: SearchResultConstants.itemColumCount)
        
        if !viewModel.localDbData.isEmpty {
            LazyVGrid(columns: columns, spacing: SearchResultConstants.itemHspacing, content: {
                ForEach($viewModel.localDbData, id: \.id) { $data in
                    InAppSearchResult(
                        data: $data, action: {
                            viewModel.likeProduct(productId: data.productId, productData: viewModel.makeLikePatchRequest(data: data))
                        })
                    .handleTapGesture(with: viewModel, data: data, source: .searchLocalProduct)
                    // TODO: - 무한 스크롤 기능
//                    .task {
//                        guard !viewModel.localDBDataIsLoading else { return }
//                        
//                        if data == viewModel.localDbData.last {
//                            viewModel.searchLocalDb(keyword: viewModel.searchText, page: viewModel.localPage)
//                        }
//                    }
                }
            })
        }
        else {
            warningText(type: .local)
        }
    }
    
    // MARK: - Common
    /// 그룹 박스 타이틀 생성 함수
    /// - Parameter text: 그룹 박스 타이틀 값
    /// - Returns: 그룹 박스 뷰 반환
    private func groupBoxTitle(_ text: String) -> some View {
        Text(text)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 검색 결과 없을 시 작성하는 경고 텍스트
    /// - Parameter type: 경고 타입
    /// - Returns: 경고 뷰 반환
    private func warningText(type: SearchType) -> some View {
        Text(type.rawValue)
            .modifier(SearchViewModifier())
    }
    
    /// 데이터 로딩 시, 처리 뷰
    /// - Parameter type: 로딩 타입
    /// - Returns: 뷰 반환
    private func loadingDataView(type: SearchType) -> some View {
        HStack {
            Spacer()
            
            ProgressView(label: {
                Text(type.loadingText)
            })
            .controlSize(.regular)
            
            Spacer()
        }
        .modifier(SearchViewModifier())
    }
    
    private func sheetBinding(data: ProductResponse) -> Binding<ProductResponse> {
        return  Binding(get: { data },
                        set: { updateProduct in
            viewModel.updateProduct(updateProduct)
        })
    }
}

struct SearchResultView_Preview: PreviewProvider {
    static var previews: some View {
        SearchResultView(viewModel: SearchViewModel(container: DIContainer()))
    }
}
