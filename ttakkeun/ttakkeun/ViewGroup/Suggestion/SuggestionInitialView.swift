//
//  SuggestionInitialView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI

struct SuggestionInitialView: View {
    
    @ObservedObject var viewModel: SuggestionViewModel
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @State private var selectedProduct: RecommenProductResponseData? = nil
    
    // MARK: - Init
    init(viewModel: SuggestionViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Contents
    var body: some View {
        VStack(spacing: 0) {
            TopStatusBar()
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    searchBar
                        .padding(.top, 10)
                    
                    if isSearching {
                        if let searchResults = viewModel.searchResults {
                            SuggestionSearchedView(dbProducts: searchResults.dbProducts, naverProducts: searchResults.naverProducts)
                        } else {
                            Text("검색 결과가 없습니다.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else {
                        Contents
                    }
                }
                .frame(maxWidth: .infinity).ignoresSafeArea(.all)
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.selectedCategory)
        }
        .sheet(item: $selectedProduct) { product in
            ProductSheetView(data: product)
                .presentationDetents([.fraction(0.62)])
                .presentationDragIndicator(Visibility.hidden)
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
    }
    
    private var searchBar: some View {
          HStack {
              if isSearching {
                  Button(action: {
                      isSearching = false
                      searchText = ""
                      viewModel.searchResults = nil
                  }) {
                      Icon.backBtn.image
                          .foregroundColor(Color.gray900)
                  }
                  .padding(.horizontal, 10)
                  .transition(.move(edge: .trailing))
              }
              
              HStack {
                  Icon.glass.image
                      .foregroundColor(.gray)
                      .padding(.leading, 5)
                  
                  TextField("검색어를 입력하세요", text: $searchText)
              }
              .frame(maxWidth: 314, maxHeight: 24)
              .padding(.horizontal, 12)
              .padding(.vertical, 10)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
              .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray200))
              .onSubmit {
                  performSearch()
              }
              .onAppear {
                  UIApplication.shared.hideKeyboard()
              }
              
              if !searchText.isEmpty {
                            Button(action: {
                                // 텍스트 필드를 초기화하는 액션
                                searchText = ""
                            }) {
                                Icon.imageRemove.image
                                    .foregroundColor(Color.gray200)
                                    .padding(.trailing, 10)
                            }
                        }
          }
      }
    // 검색 실행
    private func performSearch() {
        isSearching = true
        Task {
            await viewModel.performSearch(for: searchText)
        }
    }
    
    // 카테고리 세그먼트, AI 추천상품, 전체 추천상품
    private var Contents: some View {
        VStack(spacing: 24) {
            categorySegmentedControl
                .padding(.top, 6)
            
            if viewModel.selectedCategory == .all {
                aiProductSet
                    .padding(.top, -10)
            }
            productSet
            Spacer()
        }
    }
    
    // 카테고리 세그먼트 컨트롤
    private var categorySegmentedControl: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(RecommendProductSegment.allCases, id: \.self) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                        Task {
                            if category == .all {
                                await viewModel.getRankedProducts(page: 1)
                            } else {
                                await viewModel.getCategoryProducts(for: category.rawValue, page: 1)
                            }
                        }
                    }) {
                        Text(category.toKorean())
                            .frame(width: 40, height: 20, alignment: .center)
                            .font(.Body2_medium)
                            .foregroundStyle(Color.gray900)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .black)
                            .padding(.horizontal, 18.5)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 999)
                                    .stroke(Color.gray600, lineWidth: 2.5)
                            )
                            .background(viewModel.selectedCategory == category ? Color.primarycolor_200 : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 999))
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }
    
    // AI 추천 상품 셋
    private var aiProductSet: some View {
        VStack(spacing: -2) {
            aiRecommendProductText
                .padding(.leading, 21)
            aiRecommendProduct
        }
        .padding(.top, 17)
    }
    
    // AI 추천 상품 텍스트
    private var aiRecommendProductText: some View {
        HStack(spacing: 2) {
            Icon.recommendDog.image
                .fixedSize()
            Text("따끈따끈 AI 최근 추천")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
    }
    
    // AI 추천 상품 뷰
    private var aiRecommendProduct: some View {
        Group {
            if viewModel.aiProducts.isEmpty {
                HomeNotRecommend(firstLine: "추천 상품이 없습니다", secondLine: "AI 추천 상품을 확인하세요.")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.aiProducts) { product in
                            RecommendProductbyAI(data: product)
                                .onTapGesture {
                                    selectedProduct = product
                                }
                        }
                    }
                    .padding(.horizontal, 21)
                }
            }
        }
    }
    
    // 제품 셋
    private var productSet: some View {
        VStack(spacing: 16) {
            recommendText
            recommendProduct
        }
    }
    
    // 추천 텍스트
    private var recommendText: some View {
        HStack {
            Text("랭킹별 추천상품")
                .padding(.leading, 21)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
    }
    
    // 추천 상품 뷰
    private var recommendProduct: some View {
        VStack(spacing: 16) {
            let productsToShow = viewModel.selectedCategory == .all ? viewModel.products : viewModel.categoryProducts
            ForEach(productsToShow) { product in
                RecommendProduct(data: product, rank: productsToShow.firstIndex(of: product) ?? 0)
                    .onTapGesture {
                        selectedProduct = product
                    }
            }
        }
        .padding(.bottom, 80)
        .padding(.horizontal, 21)
    }
}

// MARK: - Preview
struct SuggestionInitialView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro", "iPhone 15 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SuggestionInitialView(viewModel: SuggestionViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
